%% extract necessary library for executable file (failed)
% including matlab MCR, generated executable file
% generate necessary library file into 'lib' directory.

% the publish directory (for_redistribution_files_only)，
proj_dir = '/data2/whd/workspace/others/matlab/app_demo/magicsquare/for_redistribution_files_only/';

out_dir = fullfile(proj_dir, 'lib');
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end


% export LD_LIBRARY_PATH=.:matlab_2018a_MCR/runtime/glnxa64/:matlab_2018a_MCR/sys/opengl/lib/glnxa64/:matlab_2018a_MCR/sys/os/glnxa64/:matlab_2018a_MCR/bin/glnxa64/
ld_lib_cmd = sprintf('export LD_LIBRARY_PATH=.:%smatlab_2018a_MCR/runtime/glnxa64/:%smatlab_2018a_MCR/sys/opengl/lib/glnxa64/:%smatlab_2018a_MCR/sys/os/glnxa64/:%smatlab_2018a_MCR/bin/glnxa64/', ...
    proj_dir, proj_dir, proj_dir, proj_dir);

exe_path = fullfile(proj_dir, 'magicsquare');
% eval(['!', ld_lib_cmd, ' & ldd ', exe_path]);
[~, ldd_out] = system(['ldd ', exe_path]);
split_ldd = splitlines(ldd_out);

for i = 1 : length(split_ldd)
    disp(split_ldd{i});
    lib_path = regexp(split_ldd{i}, '^.*.iso', 'tokens')  % ^\/(\w+\/?)+$
end
