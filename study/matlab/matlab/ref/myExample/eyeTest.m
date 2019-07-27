function tests = eyeTest
tests = functiontests(localfunctions);

function doubleClassTest(testCase)
actValue = eye;
verifyClass(testCase, actValue, 'double');

function singleClassTest(testCase)
actValue = eye('single');
verifyClass(testCase, actValue, 'single');

function unit16ClassTest(testCase)
actValue = eye('uint16');
verifyClass(testCase, actValue, 'uint16');

function sizeTest(testCase)
expSize = [7 13];
actValue = eye(expSize);
verifySize(testCase, actValue, expSize);

function valueTest(testCase)
actValue = eye(42);
verifyEqual(testCase, unique(diag(actValue)), 1);
verifyEqual(testCase, unique(triu(actValue), 1), 0);
verifyEqual(testCase, unique(tril(actValue, -1)), 0);

