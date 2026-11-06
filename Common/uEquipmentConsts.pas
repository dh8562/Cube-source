unit uEquipmentConsts;

interface

uses
  Messages, SysUtils;

const
  // 사용자 메시지
  UM_BASE = WM_USER;

  UM_AUTO_MODE_CHANGED = UM_BASE + 101;
  UM_SYSINFO_MODIFIED = UM_BASE + 102;
  UM_JOBINFO_MODIFIED = UM_BASE + 103;
  UM_UPDATE_CYCLE_TIME = UM_BASE + 104;

  UM_AXL_INTERRUPT = UM_BASE + 105;

  UM_JOB_CHANGED = UM_BASE + 110;

  UM_RECIPE_STARTED = UM_BASE + 111;
  UM_RECIPE_PROGRESS = UM_BASE + 112;
  UM_RECIPE_STEP_END = UM_BASE + 113;
  UM_RECIPE_FINISHED = UM_BASE + 114;
  UM_RECIPE_CHANGED = UM_BASE + 115;

  UM_USER_LOGIN = UM_BASE + 121;
  UM_USER_LOGOUT = UM_BASE + 122;
  UM_MAIN_MESSAGE = UM_BASE + 123;

  UM_BARCODE_INPUT = UM_BASE + 124;
  UM_SHOW_DOOR_SCREEN = UM_BASE + 125;
  UM_SHOW_EMO_SCREEN = UM_BASE + 126;
  UM_SHOW_LEAK_SCREEN = UM_BASE + 127;



const
  SSysDefaultFile = 'defsysinfo.csv';
  SSysInfoFile = 'sysinfo.xml';
  SMotionConfigChannelFile = 'MotionConfigChannels.csv';

// Job Related
const
  SJobFileExt = '.job';
  SJobFileFilter = '*' + SJobFileExt;
  SJobDefaultFile = 'default' + SJobFileExt;
  SJobBaseFile = 'defjobinfo.csv';
  SJobInfoFile = 'JobInfo';

// Recipe Related
const
  SRecipeFileExt = '.rcp';
  SRecipeFileFilter = '*.' + SRecipeFileExt;
  SRecipeDefaultFile = 'default' + SRecipeFileExt;
  SRecipeBaseFile = 'defrecipe.csv';
  SRecipeInfoFile = 'Recipe';

const
  SStatisticsChannelFile = 'statistics.csv';

const
  SIOChannelFile = 'iochannels.csv';

  SDIOChannelFile = 'diochannels.csv';
  SVirtualChannelFile = 'virtualchannels.csv';

const
  SColorPaletteFile = 'ColorPalette.xml';

const
  SCustomerLogoImageFile = 'customer.bmp';
  SCustomerLogoPngImageFile = 'customer.png';

  // INI File
const
  SGeneral = 'General';
  SActiveLanguage = 'ActiveLanguage';
  SLastJob = 'LastJob';

const
  SHalFile = 'hal.ini';
  SPlcMonitoringPacketsFile = 'plc_monitoring_packets.xml';
  SPlcPacketsLoaded = 1;
  SPlcPacketsNotLoaded = 0;

var
  JobFileFilterStr : string;
  RecipeFileFilterStr : string;

implementation


initialization
  JobFileFilterStr := Format('Job Files(*%s)|*%s', [SJobFileExt, SJobFileExt]);
  RecipeFileFilterStr := Format('Recipe Files(*%s)|*%s', [SRecipeFileExt, SRecipeFileExt]);

finalization

end.
