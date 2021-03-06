% Load and plot attenuation and dispersion from csv-files. 
% Copyright (C) 2017 Jürg Hunziker
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% The data is organized into three folders, which are:
% 1.) data_comp:    Contains the csv-files from the compression tests
% 2.) data_shear:   Contains the csv-files from the shear tests
% 3.) data_network: Contains the m-files with the geometry of the fractures
%
% The csv-files consists of 8 columns which are the following:
% 1.) time:               The logarithm with base 10 of the frequency
% 2.) MMP_eps_imag:       The imaginary part of the integrated strain
% 3.) MMP_eps_real:       The real part of the integrated strain
% 4.) MMP_sigma_imag:     The imaginary part of the integrated stress
% 5.) MMP_sigma_real:     The real part of the integrated stress
% 6.) attenuation:        Attenuation
% 7.) dispersion:         Modulus dispersion
% 8.) omega_times_volume: A control quantity depending on frequency
% Note: 
% - Integrated strain and stress are not normalized by the sample volume. 
% - Dispersion is in N/(mm^2) and needs to be multiplied by 10^6 to obtain 
%   SI units. 
% - The components of the integrated strain and stress depend on the test. 
%
% The m-files in data_network contain for each fracture network: 
% - the x-coordinate of the center point of each fracture (frac_fx_*)
% - the y-coordinate of the center point of each fracture (frac_fy_*)
% - the length of each fracture (frac_len_*)
% - the thickness (aperture) of each fracture (frac_thick_*)
% - the orientation of each fracture (frac_angle_*)
%
% Note:
% - All files need to be computed for the same amount of frequencies. 
% - Paths to directories are for linux systems. Change the orientation of
%   the slash for Windows systems. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; tic; 

% Plot attenuation (1) or not (0)
doplotatt = 1; 
% Plot dispersion (1) or not (0)
doplotdisp = 1; 
% Explore the different attenuation curves, histograms and geometries (1) or not (0)
% The bold black line shows the attenuation of the selected fracture 
% network, the grey lines the attenuation of all other fracture networks.
% The histogram of the selected fracture network is shown in grey, the mean
% histogram in red. The bottom right corner shows the geometry of the
% selected fracture network. 
doexplore = 1; 

nfiles = 20; % Amount of fracture networks
L = 400; % Size of virtual rock sample in mm
fs = 14; % Fontsize
lw = 1; % Linewidth

% Add path where the m-files are stored containing the information about
% the geometry of the fracture networks. 
addpath([pwd,'/data_network'])

% uncomment in the following selection the fracture networks belonging to
% the desired fracture statistics:

% COMPRESSION TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename_stem = 'data_comp/fracnetwork';
filename_tail = '_a1.5_dc0.0325_runmesh7.csv';
fracdist_a1p5_dc0p0325_runmesh7 % load the information about the fracture networks
% Amount of fracture connections per network:
con = [208,198,227,209,203,205,213,212,220,229,209,203,211,209,213,210,218,204,206,192]; 
% Presence of a horizontal backbone (1) or not (0):
back_horz = [0,0,1,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,1,0];
% Presence of a vertical backbone (1) or not (0):
back_vert = [1,0,0,1,0,1,1,0,1,0,0,0,0,0,1,0,1,1,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a2.25_dc0.0325_runmesh7.csv';
% fracdist_a2p25_dc0p0325_runmesh7 
% con = [226,227,221,225,216,211,182,206,204,199,207,216,220,226,220,228,208,193,235,201];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a3_dc0.0325_runmesh7.csv';
% fracdist_a3_dc0p0325_runmesh7 
% con = [191,235,253,194,198,200,215,201,210,206,220,227,206,235,221,221,229,203,210,221];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a1.5_dc0.03_runmesh7.csv';
% fracdist_a1p5_dc0p03_runmesh7 
% con = [167,180,178,174,175,170,192,166,180,198,188,196,176,186,186,190,183,189,170,174];
% back_horz = [0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a2.25_dc0.03_runmesh7.csv';
% fracdist_a2p25_dc0p03_runmesh7
% con = [163,167,160,187,182,173,188,192,178,178,167,176,171,191,182,217,176,206,190,176];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a3_dc0.03_runmesh7.csv';
% fracdist_a3_dc0p03_runmesh7
% con = [189,203,193,186,181,162,214,195,193,200,180,193,184,207,187,195,207,168,192,184];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a1.5_dc0.0275_runmesh7.csv';
% fracdist_a1p5_dc0p0275_runmesh7
% con = [137,148,140,144,143,144,159,157,162,161,174,168,151,147,187,161,169,171,153,153];
% back_horz = [0,0,1,1,0,0,1,1,0,1,0,0,0,1,0,1,0,0,0,0];
% back_vert = [0,0,0,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,1,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a2.25_dc0.0275_runmesh7.csv';
% fracdist_a2p25_dc0p0275_runmesh7
% con = [147,140,147,147,182,160,162,174,139,142,156,153,153,174,151,149,147,160,145,158];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a3_dc0.0275_runmesh7.csv';
% fracdist_a3_dc0p0275_runmesh7
% con = [145,174,150,148,144,136,144,168,162,136,168,152,164,189,154,147,149,166,170,163];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a1.5_dc0.0225_runmesh7.csv';
% fracdist_a1p5_dc0p0225_runmesh7
% con = [99,108,110,124,104,108,88,98,105,117,96,96,100,112,119,104,108,98,132,103];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a2.25_dc0.0225_runmesh7.csv';
% fracdist_a2p25_dc0p0225_runmesh7
% con = [81,114,108,84,111,98,99,93,101,110,111,105,103,109,113,99,95,96,94,96];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a3_dc0.0225_runmesh7.csv';
% fracdist_a3_dc0p0225_runmesh7
% con = [87,111,101,114,92,83,100,115,95,104,108,106,114,116,108,90,105,94,95,105];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a1.5_dc0.015_runmesh7.csv';
% fracdist_a1p5_dc0p015_runmesh7
% con = [53,48,52,43,43,40,60,48,49,53,45,49,55,54,51,46,45,59,42,53];
% back_horz = [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a2.25_dc0.015_runmesh7.csv';
% fracdist_a2p25_dc0p015_runmesh7
% con = [51,43,50,54,56,53,47,52,49,41,33,58,40,37,43,44,50,39,51,42];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_comp/fracnetwork';
% filename_tail = '_a3_dc0.015_runmesh7.csv';
% fracdist_a3_dc0p015_runmesh7
% con = [49,39,37,49,50,43,40,62,51,44,41,45,57,32,36,40,43,40,44,41];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SHEAR TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a1.5_dc0.0325_runmesh7_shear.csv';
% fracdist_a1p5_dc0p0325_runmesh7
% con = [208,198,227,209,203,205,213,212,220,229,209,203,211,209,213,210,218,204,206,192];
% back_horz = [0,0,1,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,1,0];
% back_vert = [1,0,0,1,0,1,1,0,1,0,0,0,0,0,1,0,1,1,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a2.25_dc0.0325_runmesh7_shear.csv';
% fracdist_a2p25_dc0p0325_runmesh7
% con = [226,227,221,225,216,211,182,206,204,199,207,216,220,226,220,228,208,193,235,201];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a3_dc0.0325_runmesh7_shear.csv';
% fracdist_a3_dc0p0325_runmesh7
% con = [191,235,253,194,198,200,215,201,210,206,220,227,206,235,221,221,229,203,210,221];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a1.5_dc0.03_runmesh7_shear.csv';
% fracdist_a1p5_dc0p03_runmesh7
% con = [167,180,178,174,175,170,192,166,180,198,188,196,176,186,186,190,183,189,170,174];
% back_horz = [0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a2.25_dc0.03_runmesh7_shear.csv';
% fracdist_a2p25_dc0p03_runmesh7
% con = [163,167,160,187,182,173,188,192,178,178,167,176,171,191,182,217,176,206,190,176];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a3_dc0.03_runmesh7_shear.csv';
% fracdist_a3_dc0p03_runmesh7
% con = [189,203,193,186,181,162,214,195,193,200,180,193,184,207,187,195,207,168,192,184];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a1.5_dc0.0275_runmesh7_shear.csv';
% fracdist_a1p5_dc0p0275_runmesh7
% con = [137,148,140,144,143,144,159,157,162,161,174,168,151,147,187,161,169,171,153,153];
% back_horz = [0,0,1,1,0,0,1,1,0,1,0,0,0,1,0,1,0,0,0,0];
% back_vert = [0,0,0,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,1,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a2.25_dc0.0275_runmesh7_shear.csv';
% fracdist_a2p25_dc0p0275_runmesh7
% con = [147,140,147,147,182,160,162,174,139,142,156,153,153,174,151,149,147,160,145,158];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a3_dc0.0275_runmesh7_shear.csv';
% fracdist_a3_dc0p0275_runmesh7
% con = [145,174,150,148,144,136,144,168,162,136,168,152,164,189,154,147,149,166,170,163];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a1.5_dc0.0225_runmesh7_shear.csv';
% fracdist_a1p5_dc0p0225_runmesh7
% con = [99,108,110,124,104,108,88,98,105,117,96,96,100,112,119,104,108,98,132,103];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a2.25_dc0.0225_runmesh7_shear.csv';
% fracdist_a2p25_dc0p0225_runmesh7
% con = [81,114,108,84,111,98,99,93,101,110,111,105,103,109,113,99,95,96,94,96];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a3_dc0.0225_runmesh7_shear.csv';
% fracdist_a3_dc0p0225_runmesh7
% con = [87,111,101,114,92,83,100,115,95,104,108,106,114,116,108,90,105,94,95,105];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a1.5_dc0.015_runmesh7_shear.csv';
% fracdist_a1p5_dc0p015_runmesh7
% con = [53,48,52,43,43,40,60,48,49,53,45,49,55,54,51,46,45,59,42,53];
% back_horz = [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a2.25_dc0.015_runmesh7_shear.csv';
% fracdist_a2p25_dc0p015_runmesh7
% con = [51,43,50,54,56,53,47,52,49,41,33,58,40,37,43,44,50,39,51,42];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename_stem = 'data_shear/fracnetwork';
% filename_tail = '_a3_dc0.015_runmesh7_shear.csv';
% fracdist_a3_dc0p015_runmesh7
% con = [49,39,37,49,50,43,40,62,51,44,41,45,57,32,36,40,43,40,44,41];
% back_horz = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% back_vert = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Some fixed parameters (do not change)
disp_scale = 10^6;
ifig = 1; % Number of first figure to be produced

% Load the data
for ifiles=1:nfiles
    % Load the data and skip the zeroth line (header) and the first line 
    % (data for the first step is empty)
    if ifiles < 10
        data = csvread([filename_stem,'00',num2str(ifiles),filename_tail],2);
    elseif ifiles < 100
        data = csvread([filename_stem,'0',num2str(ifiles),filename_tail],2);
    else
        data = csvread([filename_stem,num2str(ifiles),filename_tail],2);
    end
    if ifiles == 1
        freq = zeros(size(data,1),nfiles);
        att = zeros(size(data,1),nfiles);
        disp = zeros(size(data,1),nfiles);
    end
    freq(:,ifiles) = data(:,1);
    att(:,ifiles) = data(:,6);
    disp(:,ifiles) = data(:,7)*disp_scale;
    clear data
end

if doexplore==1
    % Compute the mean histogram
    edgevec = [0,20,40,60,80,100,120,140,160,180,200];
    doubleedgevec(1) = edgevec(1);
    ind = 2;
    for id=2:length(edgevec)-1
        doubleedgevec(ind:ind+1) = [edgevec(id),edgevec(id)];
        ind = ind+2;
    end
    doubleedgevec(ind) = edgevec(end);
    midpointvec = (edgevec(2:end)+edgevec(1:end-1))/2;
    allhist = zeros(nfiles,length(edgevec)-1);
    for ifiles=1:nfiles
        temp = histogram(eval(['frac_len_',num2str(ifiles)]),edgevec);
        allhist(ifiles,:) = temp.Values;
    end
    meanhist = mean(allhist,1);
    ind = 1;
    for id = 1:length(meanhist)
        doublemeanhist(ind:ind+1) = [meanhist(id),meanhist(id)];
        ind = ind+2;
    end
    
    % Start interactive plotting
    k=1;
    showrest = 1;
    redfile = 1;
    while k~=5
        figure(ifig);
        % plot attenuation
        subplot(2,2,[1,3])
        if showrest == 1
            for ifiles=1:nfiles
                loglog(10.^freq(:,ifiles),att(:,ifiles),'Color',[0.75,0.75,0.75],'Linewidth',lw)
                if ifiles == 1
                    hold on;
                end
            end
        end
        loglog(10.^freq(:,redfile),att(:,redfile),'k','Linewidth',lw+2)
        hold off
        xlim([10.^freq(1,redfile),10.^freq(end,redfile)])
        ylim([10^(-3),10^(-0.9)])
        xlabel('Frequency [Hz]','Fontsize',fs)
        ylabel('Attenuation','Fontsize',fs)
        title(['Fracture network ',num2str(redfile)],'Fontsize',fs)
        set(gca,'XTick',[10^(-4),10^0,10^4],'Fontsize',fs)
        
        % plot histogram
        subplot(222)
        histogram(eval(['frac_len_',num2str(redfile)]),edgevec,'FaceColor',[0.5,0.5,0.5])
        hold on
        plot(doubleedgevec,doublemeanhist,'r','Linewidth',2)
        hold off
        ylim([0 450]);
        xlim([0 200]);
        xlabel('Fracture length [mm]','Fontsize',fs)
        ylabel('Occurence [-]','Fontsize',fs)
        set(gca,'Fontsize',fs)
        
        % plot fracture geometry of the sample
        frac_ys = size(eval(['frac_len_',num2str(redfile)]));
        frac_xs = size(eval(['frac_len_',num2str(redfile)]));
        frac_ye = size(eval(['frac_len_',num2str(redfile)]));
        frac_xe = size(eval(['frac_len_',num2str(redfile)]));
        frac_xc = eval(['frac_fx_',num2str(redfile)])+L/2;
        frac_yc = eval(['frac_fy_',num2str(redfile)])+L/2;
        frac_angle = eval(['frac_angle_',num2str(redfile)]);
        frac_len = eval(['frac_len_',num2str(redfile)]);
        for in = 1:size(eval(['frac_len_',num2str(redfile)]),2)
            if eval(['frac_angle_',num2str(redfile),'(in)'])<45
                frac_ys(in) = frac_yc(in)-frac_len(in)*cosd(frac_angle(in))/2;
                frac_xs(in) = frac_xc(in)-frac_len(in)*sind(frac_angle(in))/2;
                frac_ye(in) = frac_yc(in)+frac_len(in)*cosd(frac_angle(in))/2;
                frac_xe(in) = frac_xc(in)+frac_len(in)*sind(frac_angle(in))/2;
            elseif frac_angle(in)>=45 && frac_angle(in)<=135
                frac_ys(in) = frac_yc(in)-frac_len(in)*sind(90-frac_angle(in))/2;
                frac_xs(in) = frac_xc(in)-frac_len(in)*cosd(90-frac_angle(in))/2;
                frac_ye(in) = frac_yc(in)+frac_len(in)*sind(90-frac_angle(in))/2;
                frac_xe(in) = frac_xc(in)+frac_len(in)*cosd(90-frac_angle(in))/2;
            else
                frac_ys(in) = frac_yc(in)+frac_len(in)*cosd(180-frac_angle(in))/2;
                frac_xs(in) = frac_xc(in)-frac_len(in)*sind(180-frac_angle(in))/2;
                frac_ye(in) = frac_yc(in)-frac_len(in)*cosd(180-frac_angle(in))/2;
                frac_xe(in) = frac_xc(in)+frac_len(in)*sind(180-frac_angle(in))/2;
            end
        end
        
        figure(ifig)
        subplot(224)
        for in = 1:size(frac_len,2)
            plot([frac_xs(in),frac_xe(in)],[frac_ys(in),frac_ye(in)],'k')
            if in == 1
                hold on;
            end
        end
        hold off
        grid on;
        xlim([0 L])
        ylim([0 L])
        axis square
        xlabel('Distance [mm]')
        ylabel('Distance [mm]')
        set(gca,'Fontsize',fs);
        
        k = menu('Press a button','next','previous','toggle rest','print','quit');
        if k == 1 % Move forward to next fracture network
            redfile = redfile + 1;
            if redfile > nfiles
                redfile = 1;
            end
        elseif k == 2 % Move back to previous fracture network
            redfile = redfile - 1;
            if redfile < 1
                redfile = nfiles;
            end
        elseif k == 3 % Toggle to plot the attenuation of the other fracture networks
            showrest = ~showrest;
        elseif k == 4 % Print a figure
            print('-dpng',[filename_stem,num2str(redfile),filename_tail(1:end-4),'.png']);
            print('-dsvg',[filename_stem,num2str(redfile),filename_tail(1:end-4),'.svg']);
        end
    end
    ifig = ifig + 1;
end

% Plot all attenuation curves
if doplotatt == 1
    for ifiles=1:nfiles
        figure(ifig);
        loglog(10.^freq(:,ifiles),att(:,ifiles),'Linewidth',lw)
        if ifiles == 1
            hold on;
        elseif ifiles == nfiles
            hold off;
        end
        grid on
        xlim([10.^freq(1,1),10.^freq(end,1)])
        xlabel('Frequency [Hz]','Fontsize',fs)
        ylabel('Attenuation','Fontsize',fs)
        set(gca,'Fontsize',fs)
    end
    ifig = ifig + 1;
end

% Plot all dispersion curves
if doplotdisp == 1
    for ifiles=1:nfiles
        figure(ifig);
        semilogx(10.^freq(:,ifiles),disp(:,ifiles)*10^(-9),'Linewidth',lw)
        if ifiles == 1
            hold on;
        elseif ifiles == nfiles
            hold off;
        end
        grid on
        xlim([10.^freq(1,1),10.^freq(end,1)])
        xlabel('Frequency [Hz]','Fontsize',fs)
        ylabel('Dispersion [GPa]','Fontsize',fs)
        set(gca,'Fontsize',fs)
    end
    ifig = ifig + 1;
end

toc