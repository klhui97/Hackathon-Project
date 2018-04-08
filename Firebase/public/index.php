<php?
use Google\Cloud\Translate\TranslateClient;

// $text = 'The text to translate."
// $targetLanguage = 'ja';  // Which language to translate to?

$translate = new TranslateClient();
$result = $translate->translate($text, [
    'target' => $targetLanguage,
]);
print("Source language: $result[source]\n");
print("Translation: $result[text]\n");