from rag.filters import check_for_age, check_hint, contains_hard_block, is_single_sentence, reveals_ending, word_count


def test_word_count_handles_diacritics_and_apostrophes():
    assert word_count("žluťoučký kůň úpěl ďábelské ódy") == 5
    assert word_count("it's a dog's life") == 4


def test_single_sentence():
    assert is_single_sentence("…a v tu chvíli se z lesa ozvalo…")
    assert is_single_sentence("Co myslíš, že liška udělala?")
    assert not is_single_sentence("Liška utekla. A pak přišel vlk.")


def test_check_hint_good():
    assert check_hint("…a v tu chvíli se z houští ozvalo…", "cs").ok
    assert check_hint("…what do you think the fox did next?", "en").ok


def test_check_hint_rejects_long():
    v = check_hint("a b c d e f g h i j k l m n o p", "en")
    assert not v.ok and "words" in v.reason


def test_check_hint_rejects_two_sentences():
    assert not check_hint("The fox ran. Then it hid.", "en").ok


def test_check_hint_rejects_closing_phrases():
    assert not check_hint("…a žili šťastně až do smrti", "cs").ok
    assert not check_hint("and they lived happily ever after", "en").ok


def test_check_hint_rejects_hard_block():
    v = check_hint("…a pak ho vlk zabil", "cs")
    assert not v.ok and "zabil" in v.reason
    # word boundary: 'krevety' (shrimp) must not trip 'krev' (blood)
    assert contains_hard_block("krevety na talíři", "cs") is None


def test_reveals_ending():
    ending = "the youngest brother marries the princess and inherits the kingdom"
    assert reveals_ending("…and the youngest brother marries the princess…", ending, "en")
    assert not reveals_ending("…what did the brother see in the forest?", ending, "en")


def test_check_for_age():
    assert not check_for_age("blood everywhere", "en", 3).ok
    assert check_for_age("blood everywhere", "en", 6).ok  # 6+ passes the rule filter; the LLM classifier decides


def test_english_hint_is_rejected_for_czech():
    # the exact failure of the first cs hints batch (2026-09-27)
    en = "The servant knelt by the spring, unaware the snake's silver scales held a secret…"
    assert not check_hint(en, "cs").ok
    assert check_hint(en, "en").ok
    assert check_hint("A pak se z křoví ozvalo něco, co nikdo nečekal…", "cs").ok
    # Czech words that happen to be English ones must not trip it
    assert check_hint("A pak liška a vlk to viděli, on to ale nevěděl…", "cs").ok
