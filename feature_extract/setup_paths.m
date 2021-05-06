function setup_paths()

% Add the neccesary paths
[pathstr, name, ext] = fileparts(mfilename('fullpath'));

% Add utils
addpath([pathstr '\utils']);

