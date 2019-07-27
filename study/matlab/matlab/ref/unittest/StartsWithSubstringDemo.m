import matlab.unittest.TestCase
import matlab.unittest.constraints.StartsWithSubstring

testCase = TestCase.forInteractiveUse;

actVal = 'This Is One Long Message';

% testCase.verifyThat(actVal, StartsWithSubstring('This'));

% testCase.verifyThat(actVal, StartsWithSubstring('thisisone', 'IgnoringCase', true, 'IgnoringWhitespace', true))

testCase.assertThat(actVal, ~StartsWithSubstring('Long'))