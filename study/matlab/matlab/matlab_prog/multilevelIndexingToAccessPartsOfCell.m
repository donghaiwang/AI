myNum = [1, 2, 3];
myCell = { 'one', 'two' };
myStruct.Fields1 = ones(3);
myStruct.Fields2 = 5*ones(5);

C = {myNum, 100*myNum;
     myCell, myStruct};
 
C{1, 2}(1,2);
C{2, 1}(1, 2);

C{2,2}.Fields2(5, 1);

C{2, 1}{2, 2} = {pi, eps};
C{2,2}.Field3 = struct('NestedField1', rand(3), ...
                       'NestedField2', magic(4), ...
                       'NestedField3', {{'text'; 'more text'}} );

copy_pi = C{2,1}{2,2}{1,1};
part_magic = C{2, 2}.Field3.NestedField2(1:2, 1:2);

nested_cell = C{2, 2}.Field3.NestedField3{2, 1};
