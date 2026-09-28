// Package gutenberg fetches and splits public-domain fairy tale
// anthologies from Project Gutenberg (STORYTELLER_PLAN.md §3.1).
package gutenberg

// Book is one Project Gutenberg ebook worth pulling motifs from.
// Collection groups related volumes (e.g. all four Lang "Fairy Books")
// so fetched files land in one subdirectory.
type Book struct {
	ID         int
	Title      string
	Author     string
	Collection string
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
	{ID: 2591, Title: "Grimms' Fairy Tales", Author: "Jacob & Wilhelm Grimm", Collection: "grimm"},
	{ID: 5314, Title: "Household Tales by Brothers Grimm", Author: "Jacob & Wilhelm Grimm", Collection: "grimm"},
	{ID: 1597, Title: "Andersen's Fairy Tales", Author: "Hans Christian Andersen", Collection: "andersen"},
	{ID: 29021, Title: "The Fairy Tales of Charles Perrault", Author: "Charles Perrault", Collection: "perrault"},

	// Lang, all twelve volumes.
	{ID: 503, Title: "The Blue Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 540, Title: "The Red Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 7277, Title: "The Green Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 640, Title: "The Yellow Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 5615, Title: "The Pink Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 6746, Title: "The Grey Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 641, Title: "The Violet Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 2435, Title: "The Crimson Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 3282, Title: "The Brown Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 3027, Title: "The Orange Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 27826, Title: "The Olive Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 28096, Title: "The Lilac Fairy Book", Author: "Andrew Lang", Collection: "lang"},

	// Aesop stays at one edition on purpose. Gutenberg carries several
	// translations of the same ~300 fables; adding them would duplicate
	// the corpus and burn LLM time re-extracting tales we already have.
	{ID: 21, Title: "Three Hundred Aesop's Fables", Author: "Aesop (trans. Townsend)", Collection: "aesop"},

	// World coverage, wave 1 (2026-09-27): every country should have 5+
	// tales. IDs and titles verified against each text's Title: header;
	// every book here splits with SplitTales into 5+ tales (survey_test.go).
	// Country / people per collection live in rag/rag/extract.py
	// (KNOWN_COUNTRY, KNOWN_PEOPLE, MIXED_ORIGIN, NO_COUNTRY).
	// Africa
	{ID: 34655, Title: "Folk Stories from Southern Nigeria, West Africa", Author: "Elphinstone Dayrell", Collection: "dayrell-nigeria"},
	{ID: 66923, Title: "West African Folk-Tales", Author: "W. H. Barker & Cecilia Sinclair", Collection: "barker-westafrica"},
	{ID: 48828, Title: "Cunnie Rabbit, Mr. Spider and the Other Beef: West African Folk Tales", Author: "Florence M. Cronise & Henry W. Ward", Collection: "cronise"},
	{ID: 58900, Title: "Where Animals Talk: West African Folk Lore Tales", Author: "Robert Hamill Nassau", Collection: "nassau"},
	{ID: 37472, Title: "Zanzibar Tales: Told by Natives of the East Coast of Africa", Author: "George W. Bateman", Collection: "zanzibar"},
	{ID: 38339, Title: "South-African Folk-Tales", Author: "James A. Honey", Collection: "honey"},
	{ID: 75833, Title: "Fairy tales from South Africa", Author: "E. J. Bourhill & J. B. Drake", Collection: "bourhill"},
	// Middle East, Asia
	{ID: 128, Title: "The Arabian Nights Entertainments", Author: "Andrew Lang (ed.)", Collection: "lang-nights"},
	{ID: 64807, Title: "Turkish fairy tales and folk tales", Author: "Ignácz Kúnos", Collection: "kunos-turkish"},
	{ID: 30577, Title: "Told in the Coffee House: Turkish Tales", Author: "Cyrus Adler & Allan Ramsay", Collection: "coffee-house"},
	{ID: 67180, Title: "Korean Fairy Tales", Author: "William Elliot Griffis", Collection: "korean-griffis"},
	{ID: 51002, Title: "Korean folk tales", Author: "Im Bang & Yi Ryuk (trans. James S. Gale)", Collection: "korean-gale"},
	{ID: 26070, Title: "Chinese Folk-Lore Tales", Author: "John Macgowan", Collection: "chinese-macgowan"},
	{ID: 18674, Title: "A Chinese Wonder Book", Author: "Norman Hinsdale Pitman", Collection: "chinese-pitman"},
	{ID: 40402, Title: "Sagas from the Far East; or, Kalmouk and Mongolian Traditionary Tales", Author: "Rachel Harriette Busk", Collection: "busk-kalmouk"},
	{ID: 66443, Title: "Wonder Tales from Tibet", Author: "Eleanore Myers Jewett", Collection: "tibet-jewett"},
	{ID: 12814, Title: "Philippine Folk Tales", Author: "Mabel Cook Cole", Collection: "philippine-cole"},
	{ID: 11028, Title: "Philippine Folk-Tales", Author: "Clara Kern Bayliss", Collection: "philippine-bayliss"},
	{ID: 35564, Title: "Laos Folk-Lore of Farther India", Author: "Katherine Neville Fleeson", Collection: "laos"},
	{ID: 56614, Title: "Village Folk-Tales of Ceylon, Volume 1 (of 3)", Author: "Henry Parker", Collection: "ceylon-parker"},
	{ID: 57399, Title: "Village Folk-Tales of Ceylon, Volume 2 (of 3)", Author: "Henry Parker", Collection: "ceylon-parker"},
	{ID: 58889, Title: "Village Folk-Tales of Ceylon, Volume 3 (of 3)", Author: "Henry Parker", Collection: "ceylon-parker"},
	{ID: 37884, Title: "Folk-Tales of the Khasis", Author: "Mrs. Rafy", Collection: "khasi"},
	{ID: 58816, Title: "Simla Village Tales; Or, Folk Tales from the Himalayas", Author: "Alice Elizabeth Dracott", Collection: "simla"},
	{ID: 6145, Title: "Tales of the Punjab: Folklore of India", Author: "Flora Annie Steel", Collection: "punjab-steel"},
	{ID: 38488, Title: "Folk-Tales of Bengal", Author: "Lal Behari Day", Collection: "bengal-day"},
	{ID: 76982, Title: "Folk tales of Sind and Guzarat", Author: "Charles Augustus Kincaid", Collection: "sind-guzarat"},
	{ID: 59401, Title: "Oral tradition from the Indus", Author: "J. F. A. McNair & Thomas Lambert Barlow", Collection: "indus-oral"},
	// Oceania
	{ID: 3833, Title: "Australian Legendary Tales: folk-lore of the Noongahburrahs as told to the Piccaninnies", Author: "K. Langloh Parker", Collection: "parker-australian"},
	{ID: 18450, Title: "Hawaiian folk tales", Author: "Thomas G. Thrum", Collection: "hawaii-thrum"},
	// Americas
	{ID: 28932, Title: "Eskimo Folk-Tales", Author: "Knud Rasmussen", Collection: "rasmussen-eskimo"},
	{ID: 61875, Title: "Animal Stories from Eskimo Land", Author: "Rhoda Cameron Riggs", Collection: "eskimo-animal"},
	{ID: 36241, Title: "Canadian Fairy Tales", Author: "Cyrus MacMillan", Collection: "canadian-macmillan"},
	{ID: 66509, Title: "Myths and Folk-lore of the Timiskaming Algonquin and Timagami Ojibwa", Author: "Frank G. Speck", Collection: "timiskaming"},
	{ID: 45852, Title: "Legends of the City of Mexico", Author: "Thomas A. Janvier", Collection: "janvier-mexico"},
	{ID: 72735, Title: "Jamaica Anansi stories", Author: "Martha Warren Beckwith", Collection: "beckwith-jamaica"},
	{ID: 24732, Title: "Myths & Legends of our New Possessions & Protectorate", Author: "Charles M. Skinner", Collection: "skinner-possessions"},
	// Europe
	{ID: 29672, Title: "Cossack Fairy Tales and Folk Tales", Author: "R. Nisbet Bain", Collection: "cossack"},
	{ID: 36668, Title: "Polish Fairy Tales", Author: "A. J. Gliński", Collection: "polish-glinski"},
	{ID: 7871, Title: "Dutch Fairy Tales for Young Folks", Author: "William Elliot Griffis", Collection: "dutch-griffis"},
	{ID: 67256, Title: "Belgian Fairy Tales", Author: "William Elliot Griffis", Collection: "belgian-griffis"},
	{ID: 46960, Title: "Beasts & Men", Author: "Jean de Bosschère", Collection: "boschere-flanders"},
	{ID: 69739, Title: "Swiss Fairy Tales", Author: "William Elliot Griffis", Collection: "swiss-griffis"},
	{ID: 44746, Title: "Household stories from the Land of Hofer; or, Popular Myths of Tirol", Author: "Rachel Harriette Busk", Collection: "tirol-busk"},
	{ID: 45859, Title: "Patrañas; or, Spanish Stories, Legendary and Traditional", Author: "Rachel Harriette Busk", Collection: "busk-patranas"},
	{ID: 31481, Title: "Tales from the Lands of Nuts and Grapes (Spanish and Portuguese Folklore)", Author: "Charles Sellers", Collection: "sellers-spain-portugal"},
	{ID: 34431, Title: "The Islands of Magic: Legends, Folk and Fairy Tales from the Azores", Author: "Elsie Spicer Eells", Collection: "azores-eells"},
	{ID: 43059, Title: "Rumanian Bird and Beast Stories Rendered into English", Author: "Moses Gaster", Collection: "rumanian-gaster"},
	{ID: 67191, Title: "Serbian Fairy Tales", Author: "Elodie L. Mijatovich", Collection: "serbian-mijatovich"},
	{ID: 51762, Title: "Manx Fairy Tales", Author: "Sophia Morrison", Collection: "manx"},
	{ID: 37532, Title: "The Scottish Fairy Book", Author: "Elizabeth W. Grierson", Collection: "scottish-grierson"},
	{ID: 9368, Title: "Welsh Fairy Tales", Author: "William Elliot Griffis", Collection: "welsh-griffis"},
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
