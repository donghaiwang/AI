% test triangles
tri = [7 9];
triIso = [4 4];
tri306090 = [2 2*sqrt(3)];
triSkewed = [1 1500];

%preconditions
angles = rightTri(tri);
assert(angles(3) == 90, 'Fundamental problem: rightTri not producing right triangle')

%% Test 1: sum of angles
angles = rightTri(tri);
assert(sum(angles) == 180)

angles = rightTri(triIso);
assert(sum(angles) == 180);

angles = rightTri(tri306090);
assert(sum(angles) == 180);

angle = rightTri(triSkewed);
assert(sum(angles) == 180);

%% Test 2: isosceles triangles
angles = rightTri(triIso);
assert(angles(1) == 45);
assert(angles(1) == angles(2));

%% Test 3: 30-60-90 triangle
angles = rightTri(tri306090);
assert(angles(1) == 30);
assert(angles(2) == 60);
assert(angles(3) == 90);

%% Test 4: Small angle approximation
angles = rightTri(triSkewed);
smallAngle = (pi/180)*angles(1);  % radians
approx = sin(smallAngle);
assert(approx == smallAngle, 'Problem with samll approximation');
