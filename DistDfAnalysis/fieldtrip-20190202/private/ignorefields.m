function ignore = ignorefields(purpose)

% IGNOREFIELDS returns a list of fields that can be present in the cfg structure that
% should be ignored at various places in the code, e.g. for provenance, history,
% size-checking, etc.

switch purpose
  
  case 'appendtimelock'
    ignore = {
      'cfg'
      'label'
      'time'
      'dimord'
      'grad'
      'elec'
      'opto'
      'fsample'
      'trialinfo'  % this is dealt with explicitly
      'sampleinfo' % this is dealt with explicitly
      'topo'
      'topolabel'
      'topodimord'
      'unmixing'
      'unmixingdimord'
      };
    
  case 'appendfreq'
    ignore = {
      'cfg'
      'label'
      'time'
      'freq'
      'dimord'
      'grad'
      'elec'
      'opto'
      'trialinfo'  % this is dealt with explicitly
      'sampleinfo' % this is dealt with explicitly
      'cumsumcnt'  % this is dealt with explicitly
      'cumtapcnt'  % this is dealt with explicitly
      };
    
  case 'deface'
    ignore = {
      % some fields should be dealt with explicitly
      'pos'
      'tri'
      'tet'
      'hex'
      'dim'
      'transform'
      % some fields are irrelevant
      'unit'
      'coordsys'
      'fid'
      'cfg'
      };
    
  case 'pipeline'
    ignore = {
      % some fields that are always allowed to be present in the configuration
      'leadfield'
      'inside'
      'cfg'
      'previous'
      };
    
  case 'allowed'
    ignore = {
      % some fields that are always allowed to be present in the configuration
      'callinfo'
      'checkconfig'
      'checkpath'
      'checksize'
      'debug'
      'notification'
      'outputfilepresent'
      'previous'
      'progress'
      'showcallinfo'
      'spmversion'
      'toolbox'
      'trackcallinfo'
      'trackconfig'
      'trackdatainfo'
      'trackusage'
      'version'
      'warning'
      };
    
  case {'rollback'}
    ignore = {
      % these should not be updated in rollback_provenance
      'callinfo'
      'checkconfig'
      'checksize'
      'debug'
      'notification'
      'previous'
      'showcallinfo'
      'trackcallinfo'
      'trackconfig'
      'trackdatainfo'
      'trackusage'
      'version'
      'warning'
      };
    
  case {'provenance', 'history'}
    ignore = {
      % these should not be included in the provenance or history
      'checkconfig'
      'checksize'
      'debug'
      'notification'
      'showcallinfo'
      'trackcallinfo'
      'trackconfig'
      'trackdatainfo'
      'trackusage'
      'warning'
      };
    
  case 'trackconfig'
    ignore = {
      % these fields from the user should be ignored
      'checksize'
      'trl'
      'trlold'
      'event'
      'artifact'
      'artfctdef'
      % these fields are for internal usage only
      'checkconfig'
      'checksize'
      'trackconfig'
      'trackusage'
      'trackdatainfo'
      'trackcallinfo'
      'showcallinfo'
      'callinfo'
      'version'
      'warning'
      'notification'
      'debug'
      'previous'
      'hastoolbox'
      };
    
  case 'checksize'
    ignore = {
      % the size of these fields should not be checked
      'checksize'
      'trl'
      'trlold'
      'event'
      'artifact'
      'artfctdef'
      'previous'
      'hastoolbox'
      };
    
  case 'makessense'
    ignore = {
      % these fields should not be used to check whether the trialinfo and sampleinfo make sense
      'label'
      'time'
      'freq'
      'hdr'
      'fsample'
      'dimord'
      'trialinfo'
      'sampleinfo'
      'grad'
      'elec'
      'opto'
      'cfg'
      };
    
  otherwise
    ft_error('invalid purpose');
end % switch purpose
