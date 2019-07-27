% toolbox\matlab\testframework\unittest\core\+matlab\+unittest\+selectors
import matlab.unittest.TestSuite;
import matlab.unittest.selectors.HasName;
import matlab.unittest.constraints.EndsWithSubstring;

suite = TestSuite.fromFile('ExampleTest.m');
{suite.Name};

s1 = suite.selectIf(HasName('ExampleTest/testPathAdd'));
{s1.Name};

s2 = suite.selectIf(HasName(EndsWithSubstring('One')) | ...
    HasName(EndsWithSubstring('Two')));
{s2.Name};

%%
import matlab.unittest.constraints.ContainsSubstring;
s2 = TestSuite.fromFile('ExampleTest.m', ...
    HasName(ContainsSubstring('One')));
