load patients.mat

BloodPressure = [Systolic Diastolic];
Gender = categorical(Gender);

whos('Gender', 'Age', 'Smoker', 'BloodPressure')

%%
T = table(Gender, Age, Smoker, BloodPressure);
T(1:5, :);


%%
StructArray = table2struct(T);
StructArray(1);

ScalarStruct = struct(...
    'Gender', {Gender}, ...
    'Age', Age, ...
    'Smoker', Smoker, ...
    'BloodPressure', BloodPressure);
