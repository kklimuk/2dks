listing = dir('./data/*')';
files = listing(~ismember({listing.name}, {'.', '..'}));
names = arrayfun(@(file) file.name, files, 'UniformOutput', false);
combinations = nchoosek(names, 2);

[numRows, numCols] = size(combinations);

results = {'First Source', 'Second Source', 'H', 'P Value', 'KS Statistic'};
for row = 1:numRows
  x1 = csvread(strcat('./data/', combinations{row, 1}));
  x2 = csvread(strcat('./data/', combinations{row, 2}));
  [H, pValue, KSstatistic] = kstest_2s_2d(x1, x2);

  results = [results; { combinations{row, 1}, combinations{row, 2}, H, pValue, KSstatistic }];
end

dlmcell('./output/results.csv', results, ',');