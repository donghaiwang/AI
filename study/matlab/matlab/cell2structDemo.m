devel = {{'Lee','Reed','Hill'}, {'Dean','Frye'}, ...
   {'Lane','Fox','King'}};
sales = {{'Howe','Burns'}, {'Kirby','Ford'}, {'Hall'}};
mgmt = {{'Price'}, {'Clark','Shea'}, {'Sims'}};
qual = {{'Bates','Gray'}, {'Nash'}, {'Kay','Chase'}};
docu = {{'Lloyd','Young'}, {'Ryan','Hart','Roy'}, {'Marsh'}};

employees = [devel; sales; mgmt; qual; docu];
employees;

rowHeadings = {'development', 'sales', 'management', ...
   'quality', 'documentation'};

depts = cell2struct(employees, rowHeadings, 1);

depts(1:2).development;

%%
colHeadings = {'fiveYears', 'tenYears', 'fifteenYears'};
years = cell2struct(employees, colHeadings, 2);

 [~, sales_5years, ~, ~, docu_5years]= years.fiveYears;
 
 %%
 rowHeadings = {'development', 'documentation'};
 
 depts = cell2struct(employees([1, 5], :), rowHeadings, 1);
 
 for k = 1 : 3
     depts(k, :);
 end