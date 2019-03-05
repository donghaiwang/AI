%% MDCE configuration
%% Constant values
%
toolsPath = fileparts(fileparts(mfilename('fullpath')));
ssh2Path = fullfile(toolsPath, 'ssh2');
addpath(ssh2Path);

%%
distcompBinPath = fullfile(toolboxdir('distcomp'), 'bin');
% addpath(distcompBinPath);

curPath = pwd;
eval(['cd ' distcompBinPath]);

!mdce install
!mdce start

%% Add hostname to hosts
if ispc
    hostsFullpath = 'C:\Windows\System32\drivers\etc\hosts';
end

hostsInfo = importdata('hosts');

fp = fopen(hostsFullpath, 'a+');  % need administrator to modify hosts
for i = 1 : size(hostsInfo, 1)
    fprintf(fp, [hostsInfo{i} newline]);
end
fclose(fp);

%%
% !admincenter.%bat

%% SSH
% [a astr]=system('echo %USERNAME%');
% system('hostname')
% getenv('USERNAME')

% HOSTNAME = 'server';
% USERNAME = 'Administrator';
% PASSWORD = 'Admin123';
% HOSTNAME = 'DESKTOP-1RLTDPV';

% HOSTNAME = 'DESKTOP-1RLTDPV';
% USERNAME = 'd';
% PASSWORD = 'd';
% ssh2_conn = ssh2_config(HOSTNAME, USERNAME, PASSWORD);
% ssh2_conn = ssh2_command(ssh2_conn, 'ls -la *')




%% return to previous directory
eval(['cd ' curPath]);