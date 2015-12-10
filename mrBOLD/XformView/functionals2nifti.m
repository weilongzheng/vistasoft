function functionals2nifti(vw, scan, outpth)
% 
% functionals2nifti(vw, [scan], [outpth])
% 
% AUTHOR:  JW (ported from functionals2mrGray)
% DATE:  jan, 2009
% PURPOSE:
%   Writes out the functional data currently on display in the
%   volume window into a nifti file.
%   
% vw: structure that contains all the information
%       related to the volume functional data and user interface.
% 
%
% Example: Export the current map
%   vw = getSelectedGray;
%   functionals2nifti(vw);


mrGlobals;

% Figure out which scan is being viewed.
if notDefined('scan'), scan = viewGet(vw, 'current scan'); end

% Extract the data being displayed and the corresponding locations
data = getCurData(vw, viewGet(vw, 'displayMode'), scan);

% Convert mrVista format to our preferred axial format for NIFTI
mmPerVox = viewGet(vw, 'mmPerVox');
data = mrLoadRet2nifti(data, mmPerVox); 

% Replace NaNs with 0s�
data(isnan(data)) = 0;

%Load t1 to get xforms correct
t1 = niftiRead(vANATOMYPATH);
qto = niftiGet(t1, 'qto_xyz');

% Create nifti to export with transform matched to t1
ni = niftiCreate('data', data, 'qto_xyz', qto);

% name and path to save file
if notDefined('outpth'), ni.fname = fullfile(fileparts(vANATOMYPATH), ['functionalOverlay-' datestr(now,1) '.nii.gz']);
else  ni.fname = outpth; end
    
writeFileNifti(ni);

fprintf('Functional data saved as %s.\n', ni.fname);

return;