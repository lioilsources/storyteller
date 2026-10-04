// Package gutenberg fetches and splits public-domain fairy tale
// anthologies from Project Gutenberg (STORYTELLER_PLAN.md §3.1).
package gutenberg

import "strconv"

// Book is one Project Gutenberg ebook worth pulling motifs from.
// Collection groups related volumes (e.g. all four Lang "Fairy Books")
// so fetched files land in one subdirectory.
type Book struct {
	ID         int
	Title      string
	Author     string
	Collection string

	// Lang is the language of the text we download (BCP-47, "en"), not
	// of the tradition: Georgian tales read in Wardrop's English are
	// "en". It is written to the sidecar JSON so the pipeline knows what
	// it is reading. User rule (2026-10-04): take the original when it is
	// in a language we create content in, otherwise English — never a
	// translation that went through Czech.
	Lang string

	// Archive, when set, fetches the book from an Internet Archive item
	// instead of Gutenberg (ID stays 0). Only for books Gutenberg does
	// not carry; the text is OCR, so such books always use Titles.
	Archive *ArchiveItem
	// License is required for Archive books, which carry no PG licence
	// header: why the text is public domain (publication year, author's
	// death year).
	License string

	// Titles, when set, replaces CONTENTS parsing: the tale headings as
	// printed in the body, in order. For books whose contents block the
	// heuristic cannot read (reflowed, roman numerals with one space,
	// headings worded differently from the contents) or that have none.
	// Every title must be found, or the fetch fails — an explicit list
	// that silently loses a tale would be worse than the heuristic.
	// Matching ignores case, whitespace runs, emphasis, and trailing
	// punctuation / footnote markers ("KARA KOS SULU 2", `"A LAUNG
	// KHIT."[1]`), and accepts a heading wrapped over two lines.
	Titles []string
	// Start (required with Titles) is the beginning of the line where
	// the search for Titles begins — past the contents block, so a title
	// cannot match its own listing. End, optional, is the beginning of
	// the line where the last tale stops (the next people's section in
	// Coxwell). Both compare case- and whitespace-insensitively.
	Start, End string

	// TaleCountry assigns an ISO 3166-1 alpha-2 origin to single tales
	// of a mixed collection, keyed by their entry in Titles, where the
	// book itself says where the tale is from ("In Colombia, it seems…").
	// Written to index.json as "country"; rag.extract prefers it to the
	// model's guess. Tales not listed are left to the model.
	TaleCountry map[string]string
}

// ArchiveItem is a text file inside an Internet Archive item.
type ArchiveItem struct {
	ID   string // item identifier, archive.org/details/<ID>
	File string // the OCR text file, usually <ID>_djvu.txt
}

// Key names the book's files on disk and its part of source_ref:
// the Gutenberg ID, or the Internet Archive identifier.
func (b Book) Key() string {
	if b.Archive != nil {
		return b.Archive.ID
	}
	return strconv.Itoa(b.ID)
}

// Source is the first part of source_ref for this book's tales.
func (b Book) Source() string {
	if b.Archive != nil {
		return "archive"
	}
	return "gutenberg"
}

// Catalog IDs are verified, not guessed: every entry's expected Title
// below was checked against the "Title:" header of the actual fetched
// text — the original nine by hand on 2026-09-24, the eight Lang volumes
// added on 2026-09-25 by enumerating Lang's Gutenberg author page (author
// id 79) and reading each candidate's header. `Fetch` now re-checks the
// header on every run, so a wrong or re-numbered ID fails loudly instead
// of silently saving the wrong book.
//
// Lang's twelve "coloured fairy books" are the reason this catalog is
// worth having: unlike Grimm (all German) or Andersen (all Danish), each
// Lang volume gathers tales from a dozen different nations, which is what
// the globe (§1.1b) needs before most of the planet stops being grey.
// Note the flip side — their origin cannot be assigned per collection,
// only per tale, so `rag.extract`'s KNOWN_COUNTRY override must not be
// applied to them.
var Catalog = []Book{
	{ID: 2591, Title: "Grimms' Fairy Tales", Author: "Jacob & Wilhelm Grimm", Collection: "grimm", Lang: "en"},
	{ID: 5314, Title: "Household Tales by Brothers Grimm", Author: "Jacob & Wilhelm Grimm", Collection: "grimm", Lang: "en"},
	{ID: 1597, Title: "Andersen's Fairy Tales", Author: "Hans Christian Andersen", Collection: "andersen", Lang: "en"},
	{ID: 29021, Title: "The Fairy Tales of Charles Perrault", Author: "Charles Perrault", Collection: "perrault", Lang: "en"},

	// Lang, all twelve volumes.
	{ID: 503, Title: "The Blue Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 540, Title: "The Red Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 7277, Title: "The Green Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 640, Title: "The Yellow Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 5615, Title: "The Pink Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 6746, Title: "The Grey Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 641, Title: "The Violet Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 2435, Title: "The Crimson Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 3282, Title: "The Brown Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 3027, Title: "The Orange Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 27826, Title: "The Olive Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},
	{ID: 28096, Title: "The Lilac Fairy Book", Author: "Andrew Lang", Collection: "lang", Lang: "en"},

	// Aesop stays at one edition on purpose. Gutenberg carries several
	// translations of the same ~300 fables; adding them would duplicate
	// the corpus and burn LLM time re-extracting tales we already have.
	{ID: 21, Title: "Three Hundred Aesop's Fables", Author: "Aesop (trans. Townsend)", Collection: "aesop", Lang: "en"},

	// World coverage, wave 1 (2026-09-27): every country should have 5+
	// tales. IDs and titles verified against each text's Title: header;
	// every book here splits with SplitTales into 5+ tales (survey_test.go).
	// Country / people per collection live in rag/rag/extract.py
	// (KNOWN_COUNTRY, KNOWN_PEOPLE, MIXED_ORIGIN, NO_COUNTRY).
	// Africa
	{ID: 34655, Title: "Folk Stories from Southern Nigeria, West Africa", Author: "Elphinstone Dayrell", Collection: "dayrell-nigeria", Lang: "en"},
	{ID: 66923, Title: "West African Folk-Tales", Author: "W. H. Barker & Cecilia Sinclair", Collection: "barker-westafrica", Lang: "en"},
	{ID: 48828, Title: "Cunnie Rabbit, Mr. Spider and the Other Beef: West African Folk Tales", Author: "Florence M. Cronise & Henry W. Ward", Collection: "cronise", Lang: "en"},
	{ID: 58900, Title: "Where Animals Talk: West African Folk Lore Tales", Author: "Robert Hamill Nassau", Collection: "nassau", Lang: "en"},
	{ID: 37472, Title: "Zanzibar Tales: Told by Natives of the East Coast of Africa", Author: "George W. Bateman", Collection: "zanzibar", Lang: "en"},
	{ID: 38339, Title: "South-African Folk-Tales", Author: "James A. Honey", Collection: "honey", Lang: "en"},
	{ID: 75833, Title: "Fairy tales from South Africa", Author: "E. J. Bourhill & J. B. Drake", Collection: "bourhill", Lang: "en"},
	// Middle East, Asia
	{ID: 128, Title: "The Arabian Nights Entertainments", Author: "Andrew Lang (ed.)", Collection: "lang-nights", Lang: "en"},
	{ID: 64807, Title: "Turkish fairy tales and folk tales", Author: "Ignácz Kúnos", Collection: "kunos-turkish", Lang: "en"},
	{ID: 30577, Title: "Told in the Coffee House: Turkish Tales", Author: "Cyrus Adler & Allan Ramsay", Collection: "coffee-house", Lang: "en"},
	{ID: 67180, Title: "Korean Fairy Tales", Author: "William Elliot Griffis", Collection: "korean-griffis", Lang: "en"},
	{ID: 51002, Title: "Korean folk tales", Author: "Im Bang & Yi Ryuk (trans. James S. Gale)", Collection: "korean-gale", Lang: "en"},
	{ID: 26070, Title: "Chinese Folk-Lore Tales", Author: "John Macgowan", Collection: "chinese-macgowan", Lang: "en"},
	{ID: 18674, Title: "A Chinese Wonder Book", Author: "Norman Hinsdale Pitman", Collection: "chinese-pitman", Lang: "en"},
	{ID: 40402, Title: "Sagas from the Far East; or, Kalmouk and Mongolian Traditionary Tales", Author: "Rachel Harriette Busk", Collection: "busk-kalmouk", Lang: "en"},
	{ID: 66443, Title: "Wonder Tales from Tibet", Author: "Eleanore Myers Jewett", Collection: "tibet-jewett", Lang: "en"},
	{ID: 12814, Title: "Philippine Folk Tales", Author: "Mabel Cook Cole", Collection: "philippine-cole", Lang: "en"},
	{ID: 11028, Title: "Philippine Folk-Tales", Author: "Clara Kern Bayliss", Collection: "philippine-bayliss", Lang: "en"},
	{ID: 35564, Title: "Laos Folk-Lore of Farther India", Author: "Katherine Neville Fleeson", Collection: "laos", Lang: "en"},
	{ID: 56614, Title: "Village Folk-Tales of Ceylon, Volume 1 (of 3)", Author: "Henry Parker", Collection: "ceylon-parker", Lang: "en"},
	{ID: 57399, Title: "Village Folk-Tales of Ceylon, Volume 2 (of 3)", Author: "Henry Parker", Collection: "ceylon-parker", Lang: "en"},
	{ID: 58889, Title: "Village Folk-Tales of Ceylon, Volume 3 (of 3)", Author: "Henry Parker", Collection: "ceylon-parker", Lang: "en"},
	{ID: 37884, Title: "Folk-Tales of the Khasis", Author: "Mrs. Rafy", Collection: "khasi", Lang: "en"},
	{ID: 58816, Title: "Simla Village Tales; Or, Folk Tales from the Himalayas", Author: "Alice Elizabeth Dracott", Collection: "simla", Lang: "en"},
	{ID: 6145, Title: "Tales of the Punjab: Folklore of India", Author: "Flora Annie Steel", Collection: "punjab-steel", Lang: "en"},
	{ID: 38488, Title: "Folk-Tales of Bengal", Author: "Lal Behari Day", Collection: "bengal-day", Lang: "en"},
	{ID: 76982, Title: "Folk tales of Sind and Guzarat", Author: "Charles Augustus Kincaid", Collection: "sind-guzarat", Lang: "en"},
	{ID: 59401, Title: "Oral tradition from the Indus", Author: "J. F. A. McNair & Thomas Lambert Barlow", Collection: "indus-oral", Lang: "en"},
	// Oceania
	{ID: 3833, Title: "Australian Legendary Tales: folk-lore of the Noongahburrahs as told to the Piccaninnies", Author: "K. Langloh Parker", Collection: "parker-australian", Lang: "en"},
	{ID: 18450, Title: "Hawaiian folk tales", Author: "Thomas G. Thrum", Collection: "hawaii-thrum", Lang: "en"},
	// Americas
	{ID: 28932, Title: "Eskimo Folk-Tales", Author: "Knud Rasmussen", Collection: "rasmussen-eskimo", Lang: "en"},
	{ID: 61875, Title: "Animal Stories from Eskimo Land", Author: "Rhoda Cameron Riggs", Collection: "eskimo-animal", Lang: "en"},
	{ID: 36241, Title: "Canadian Fairy Tales", Author: "Cyrus MacMillan", Collection: "canadian-macmillan", Lang: "en"},
	{ID: 66509, Title: "Myths and Folk-lore of the Timiskaming Algonquin and Timagami Ojibwa", Author: "Frank G. Speck", Collection: "timiskaming", Lang: "en"},
	{ID: 45852, Title: "Legends of the City of Mexico", Author: "Thomas A. Janvier", Collection: "janvier-mexico", Lang: "en"},
	{ID: 72735, Title: "Jamaica Anansi stories", Author: "Martha Warren Beckwith", Collection: "beckwith-jamaica", Lang: "en"},
	{ID: 24732, Title: "Myths & Legends of our New Possessions & Protectorate", Author: "Charles M. Skinner", Collection: "skinner-possessions", Lang: "en"},
	// Europe
	{ID: 29672, Title: "Cossack Fairy Tales and Folk Tales", Author: "R. Nisbet Bain", Collection: "cossack", Lang: "en"},
	{ID: 36668, Title: "Polish Fairy Tales", Author: "A. J. Gliński", Collection: "polish-glinski", Lang: "en"},
	{ID: 7871, Title: "Dutch Fairy Tales for Young Folks", Author: "William Elliot Griffis", Collection: "dutch-griffis", Lang: "en"},
	{ID: 67256, Title: "Belgian Fairy Tales", Author: "William Elliot Griffis", Collection: "belgian-griffis", Lang: "en"},
	{ID: 46960, Title: "Beasts & Men", Author: "Jean de Bosschère", Collection: "boschere-flanders", Lang: "en"},
	{ID: 69739, Title: "Swiss Fairy Tales", Author: "William Elliot Griffis", Collection: "swiss-griffis", Lang: "en"},
	{ID: 44746, Title: "Household stories from the Land of Hofer; or, Popular Myths of Tirol", Author: "Rachel Harriette Busk", Collection: "tirol-busk", Lang: "en"},
	{ID: 45859, Title: "Patrañas; or, Spanish Stories, Legendary and Traditional", Author: "Rachel Harriette Busk", Collection: "busk-patranas", Lang: "en"},
	{ID: 31481, Title: "Tales from the Lands of Nuts and Grapes (Spanish and Portuguese Folklore)", Author: "Charles Sellers", Collection: "sellers-spain-portugal", Lang: "en"},
	{ID: 34431, Title: "The Islands of Magic: Legends, Folk and Fairy Tales from the Azores", Author: "Elsie Spicer Eells", Collection: "azores-eells", Lang: "en"},
	{ID: 43059, Title: "Rumanian Bird and Beast Stories Rendered into English", Author: "Moses Gaster", Collection: "rumanian-gaster", Lang: "en"},
	{ID: 67191, Title: "Serbian Fairy Tales", Author: "Elodie L. Mijatovich", Collection: "serbian-mijatovich", Lang: "en"},
	{ID: 51762, Title: "Manx Fairy Tales", Author: "Sophia Morrison", Collection: "manx", Lang: "en"},
	{ID: 37532, Title: "The Scottish Fairy Book", Author: "Elizabeth W. Grierson", Collection: "scottish-grierson", Lang: "en"},
	{ID: 9368, Title: "Welsh Fairy Tales", Author: "William Elliot Griffis", Collection: "welsh-griffis", Lang: "en"},

	// World coverage, wave 2 (2026-10-04): regions still grey after wave
	// 1 — South and Central America, South-East Asia, Arabia, Central
	// Asia and the Caucasus. Found by searching Gutenberg's own catalog
	// (pg_catalog.csv, subjects "Tales/Folklore/Legends -- <place>") and
	// Internet Archive; every text is English, since none of these
	// traditions has an original in a language we create content in.
	// Origins live in rag/rag/extract.py as for wave 1, plus TaleCountry
	// here for single tales of a mixed book.
	// South and Central America
	{ID: 68292, Title: "Tales from silver lands", Author: "Charles J. Finger", Collection: "finger-silver-lands", Lang: "en",
		// Contents use roman numerals with one space ("I A TALE OF…"),
		// which the CONTENTS heuristic cannot tell from a title word.
		Start: "WOODCUTS", End: "THE END",
		Titles: []string{
			"A Tale of Three Tails", "The Magic Dog", "The Calabash Man", "Na-Ha the Fighter",
			"The Humming-Bird and the Flower", "The Magic Ball", "El Enano", "The Hero Twins",
			"The Four Hundred", "The Killing of Cabrakan", "The Tale of the Gentle Folk",
			"The Tale That Cost a Dollar", "The Magic Knot", "The Bad Wishers", "The Hungry Old Witch",
			"The Wonderful Mirror", "The Tale of the Lazy People", "Rairu and the Star Maiden",
			"The Cat and the Dream Man",
		},
		// Only where Finger names the place himself; the rest (jungle
		// temples, Cape Horn, the Andes) stay with the model.
		TaleCountry: map[string]string{
			"A Tale of Three Tails":       "HN", // "Down in Honduras there is a town…"
			"The Calabash Man":            "GY", // "If you go to Guiana…"
			"The Magic Ball":              "AR", // "A Tale of the Chuput Country" (Chubut)
			"The Hero Twins":              "GT", // these three retell the K'iche' Popol Vuh
			"The Four Hundred":            "GT",
			"The Killing of Cabrakan":     "GT",
			"The Hungry Old Witch":        "UY", // "…near a forest where now is Uruguay"
			"The Tale of the Lazy People": "CO", // "In Colombia, it seems…"
			"Rairu and the Star Maiden":   "BR", // told by "my friend Pedro of Brazil"
			"The Cat and the Dream Man":   "BO", // "…said that it was a tale of Bolivia"
		},
	},
	{ID: 21678, Title: "Tales of Giants from Brazil", Author: "Elsie Spicer Eells", Collection: "eells-brazil", Lang: "en"},
	{ID: 24714, Title: "Fairy Tales from Brazil: How and Why Tales from Brazilian Folk-Lore", Author: "Elsie Spicer Eells", Collection: "eells-brazil", Lang: "en",
		// Body headings are title case and some wrap over two lines.
		Start: "How Night Came",
		Titles: []string{
			"How Night Came", "How the Rabbit Lost His Tail", "How the Toad Got His Bruises",
			"How the Tiger Got His Stripes", "Why the Lamb Is Meek", "Why the Tiger and the Stag Fear Each Other",
			"How the Speckled Hen Got Her Speckles", "How the Monkey Became a Trickster",
			"How the Monkey and the Goat Earned Their Reputations", "How the Monkey Got a Drink When He Was Thirsty",
			"How the Monkey Got Food When He Was Hungry", "Why the Bananas Belong to the Monkey",
			"How the Monkey Escaped Being Eaten", "Why the Monkey Still Has a Tail", "How Black Became White",
			"How the Pigeon Became a Tame Bird", "Why the Sea Moans", "How the Brazilian Beetles Got Their Gorgeous Coats",
		},
	},
	{ID: 42823, Title: "The Stories of El Dorado", Author: "Frona Eunice Wait", Collection: "wait-el-dorado", Lang: "en"},
	// South-East Asia
	{ID: 32375, Title: "Shan Folk Lore Stories from the Hill and Water Country", Author: "William Charles Griggs", Collection: "shan-griggs", Lang: "en",
		// Two body headings differ from the contents ("A LAUNG KHIT."[1],
		// "STORY OF THE PRINCESS…" without "THE").
		Start: "FOLK LORE STORIES", End: "GLOSSARY OF TERMS",
		Titles: []string{
			"A Laung Khit", "How Boh Han Me Got His Title", "The Two Chinamen",
			"Story of the Princess Nang Kam Ung", "How the Hare Deceived the Tiger", "The Story of the Tortoise",
			"The Sparrow's Wonderful Brood", "How the World Was Created", "How the King of Pagan Caught the Thief",
		},
	},
	{ID: 36171, Title: "Told on the Pagoda: Tales of Burmah", Author: "Mimosa", Collection: "burma-pagoda", Lang: "en"},
	{Title: "Fables [and] folk-tales from an eastern forest", Author: "Walter William Skeat", Collection: "skeat-malay", Lang: "en",
		Archive: &ArchiveItem{ID: "fablesandfolktal00skeauoft", File: "fablesandfolktal00skeauoft_djvu.txt"},
		License: "public domain: Cambridge University Press 1901; Skeat d. 1953 (IA: NOT_IN_COPYRIGHT)",
		Start:   "INTRODUCTION",
		Titles: []string{
			"Father 'Lime-stick' and the Flower-pecker", "The King of the Tigers is Sick", "The Mouse-deer's Shipwreck",
			"Who killed the Otter's Babies?", "A Vegetarian Dispute", "The Friendship of the Squirrel and the Creeping Fish",
			"The Pelican's Punishment", "The Tiger gets his Deserts", "The Tiger's Mistake",
			"The Tune that makes the Tiger drowsy", `The "Tigers' Fold."`, "The Tiger and the Shadow", "Wit wins the Day",
			"The King-crow and the Water-snail", "Father 'Follow-my-nose' and the Four Priests",
			"The Elephant Princess and the Prince", "The Elephant has a Bet with the Tiger",
			"Princess Sadong of the Caves, who Refused her Suitors",
			"The Saint that was shot out of his own Gannon", // sic: the OCR reads "Cannon" as "GANNON"
			"The Saints whose Grave-stones moved", "Nakhoda Ragam who was Pricked to Death by his Wife's Needle",
			"The Legend of Patani", "A Malayan Deluge", "King Solomon and the Birds", "The Outwitting of the Gedembai",
			"The Fate of the Silver Prince and Princess Lemon-grass",
			Cut("Notes"),
		},
	},
	// Arabian Peninsula: the only tale book Gutenberg has that is not
	// another Arabian Nights edition. Told in a Levantine garden, set in
	// part in Yemen — origin per tale, by the model.
	{ID: 73256, Title: "Told in the gardens of Araby", Author: "Izora C. Chandler & Mary Williams Montgomery (trans.)", Collection: "araby-chandler", Lang: "en"},
	// Caucasus and Central Asia
	{ID: 44536, Title: "Georgian Folk Tales", Author: "Marjory Wardrop (trans.)", Collection: "georgian-wardrop", Lang: "en",
		// Contents entries end in commas and the body numbers each tale
		// on its own line above the heading, with footnote marks.
		Start: "PART I", End: "NOTES",
		Titles: []string{
			"Master and Pupil", "The Three Sisters and their Stepmother", "The Good-for-Nothing", "The Frog's Skin",
			"Fate", "Ghvthisavari (I am of God)", "The Serpent and the Peasant", "Gulambara and Sulambara",
			"The Two Brothers", "The Prince", "Conkiajgharuna", "Asphurtzela", "The Shepherd and the Child of Fortune",
			"The Two Thieves", "The Fox and the King's Son", "The King and the Apple",
			// Mingrelian tales
			"The Three Precepts", "Kazha-ndii", "The Story of Geria, the Poor Man's Son",
			"The Prince who Befriended the Beasts", "The Cunning Old Man and the Demi", "Sanartia",
			"The Shepherd Judge", "The Priest's Youngest Son", Cut("Mingrelian Proverbs"),
			// Gurian tales
			"The Strong Man and the Dwarf", "The Grasshopper and the Ant", "The Countryman and the Merchant",
			"The King and the Sage", "The King's Son", "Teeth and No-Teeth", "The Queen's Whim",
			"The Fool's Good Fortune", "Two Losses", "The Story of Dervish", "The Father's Prophecy",
			"The Hermit Philosopher", "The King's Counsellor", "A Witty Answer",
		},
	},
	{ID: 46944, Title: "The Golden Maiden, and other folk tales and fairy stories told in Armenia", Author: "A. G. Seklemian", Collection: "armenian-seklemian", Lang: "en",
		// No CONTENTS heading at all (the list is headed "TALES."); the
		// closing ballad is verse and stays out.
		Start: "TALES.", End: "SIA-MANTO AND GUJE-ZARE",
		Titles: []string{
			"The Golden Maiden", "The Betrothed of Destiny", "The Youngest of the Three", "The Fairy Nightingale",
			"The Dreamer", "The Bride of the Fountain", "The Coward-Hero", "Zoolvisia", "Dragon-Child and Sun-Child",
			"Mirza", "The Magic Ring", "The Twins", "The Idiot", "Bedik and the Invulnerable Giant",
			"Simon, the Friend of Snakes", "The Poor Widow's Son", "A Niggardly Companion", "The Maiden of the Sea",
			// Already in the corpus: Lang retold it from the Armenian in
			// the Olive Fairy Book (lang:27826:014, extracted as AM).
			Cut("The Golden-Headed Fish"),
			"The Wicked Stepmother", "The Tricks of a Woman", "A Wise Weaver",
			"The World's Beauty", "Salman and Rostom", "The Sparrow and the Two Children", "The Old Woman and the Cat",
		},
	},
	{ID: 35577, Title: "Caucasian Legends", Author: "Abraam Gulbat (trans. S. Veselitsky-Bozhidarovich)", Collection: "caucasian-gulbat", Lang: "en"},
	// Coxwell gathers the whole Tsarist empire in ~1,000 pages; only the
	// Kirghiz, Turkoman and Darvash sections are fetched (Start/Cut/End). His
	// "Kirghiz" are mostly what is now called Kazakh — the tales cited
	// from Radlov's vol. III ("Kirgisische Mundarten") are Kazakh.
	{Title: "Siberian And Other Folk Tales", Author: "C. Fillingham Coxwell", Collection: "coxwell-central-asia", Lang: "en",
		Archive: &ArchiveItem{ID: "siberian-and-other-folk-tales", File: "Siberian and other folk tales_djvu.txt"},
		License: "public domain: London, C. W. Daniel 1925; Coxwell d. 1940",
		Start:   "The Kirghiz inhabit an area", End: "BIBLIOGRAPHY OF AUTHORS",
		Titles: []string{
			"Kara Kos Sulu", "The Young Fisherman", "The Three Sons", "How Good and Evil were Companions",
			"The Child Taught by the Mollah", "The Trick of the Fox", "Khan Schentai",
			"The Fight between Father and Son", "The Hero Kysyl-Batyr", "The Blind Man",
			"Kirghiz Traditions Concerning Mountains", Cut("Notes"),
			"The Forty Stories", Cut("A Note"),
			// Everything from the Tchuvashes to the Ossetes and Armenians
			// is skipped, up to the book's last people: the Darvashes of
			// Darvaz in the Pamirs (today Tajikistan), one tale.
			Cut("The Tchuvashes"),
			"The Magic Objects", Cut("Note"),
		},
		TaleCountry: map[string]string{
			"Kara Kos Sulu": "KZ", "The Young Fisherman": "KZ", "The Three Sons": "KZ",
			"How Good and Evil were Companions": "KZ", "The Child Taught by the Mollah": "KZ",
			"The Trick of the Fox": "KZ", "Khan Schentai": "KZ", // all Radlov III
			"The Forty Stories": "TM",
			"The Magic Objects": "TJ",
		},
	},
}

// ByCollections filters the catalog; an empty set returns everything.
func ByCollections(names map[string]bool) []Book {
	if len(names) == 0 {
		return Catalog
	}
	var out []Book
	for _, b := range Catalog {
		if names[b.Collection] {
			out = append(out, b)
		}
	}
	return out
}
