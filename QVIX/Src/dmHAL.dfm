object HAL: THAL
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 496
  Width = 512
  object SysServer: TfoDataServer
    OnError = DataServerError
    Channels = <
      item
        Category = 'General'
        DisplayName = 'ACTIVE_LANGUAGE'
        Name = 'ACTIVE_LANGUAGE'
        Tag = 0
        Value = 2
        ZDescription = '0:English;1:Korean;2:Chiness'
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'DRAIN_TANK_N2_LINE_IN_HI'
        Name = 'DRAIN_TANK_N2_LINE_IN_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'DRAIN_TANK_N2_LINE_IN_LO'
        Name = 'DRAIN_TANK_N2_LINE_IN_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'DRUM_SUPPLY_LINE_PRESSURE_HI'
        Name = 'DRUM_SUPPLY_LINE_PRESSURE_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'DRUM_SUPPLY_LINE_PRESSURE_LO'
        Name = 'DRUM_SUPPLY_LINE_PRESSURE_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Communication'
        DataType = dtString
        DisplayName = 'DTS_CONTROL_HOST'
        Name = 'DTS_CONTROL_HOST'
        Tag = 0
        Value = '127.0.0.1'
        ZDescription = 'Modbus TCP server address'
      end
      item
        Category = 'Communication'
        DataType = dtString
        DisplayName = 'DTS_CONTROL_PORT'
        Name = 'DTS_CONTROL_PORT'
        Tag = 0
        Value = '5000'
        ZDescription = 'Modbus TCP port'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_001_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_001_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 1 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_001_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_001_START_ADDRESS'
        Tag = 0
        Value = 6000
        ZDescription = 'Pipe 1 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_002_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_002_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 2 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_002_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_002_START_ADDRESS'
        Tag = 0
        Value = 8000
        ZDescription = 'Pipe 2 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_003_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_003_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 3 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_003_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_003_START_ADDRESS'
        Tag = 0
        Value = 10000
        ZDescription = 'Pipe 3 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_004_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_004_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 4 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_004_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_004_START_ADDRESS'
        Tag = 0
        Value = 12000
        ZDescription = 'Pipe 4 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_005_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_005_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 5 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_005_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_005_START_ADDRESS'
        Tag = 0
        Value = 14000
        ZDescription = 'Pipe 5 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_006_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_006_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 6 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_006_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_006_START_ADDRESS'
        Tag = 0
        Value = 16000
        ZDescription = 'Pipe 6 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_007_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_007_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 7 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_007_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_007_START_ADDRESS'
        Tag = 0
        Value = 18000
        ZDescription = 'Pipe 7 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_008_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_008_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 8 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_008_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_008_START_ADDRESS'
        Tag = 0
        Value = 20000
        ZDescription = 'Pipe 8 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_009_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_009_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 9 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_009_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_009_START_ADDRESS'
        Tag = 0
        Value = 22000
        ZDescription = 'Pipe 9 Modbus start address'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_010_READ_QUANTITY'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_010_READ_QUANTITY'
        Tag = 0
        Value = 2000
        ZDescription = 'Pipe 10 total word count'
      end
      item
        Category = 'Communication'
        DisplayName = 'DTS_PIPE_010_START_ADDRESS'
        Min = 1.000000000000000000
        Max = 65535.000000000000000000
        Name = 'DTS_PIPE_010_START_ADDRESS'
        Tag = 0
        Value = 24000
        ZDescription = 'Pipe 10 Modbus start address'
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_DRAIN_TANK_N2_LINE_IN'
        Name = 'FACTOR_DRAIN_TANK_N2_LINE_IN'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_DRUM_SUPPLY_LINE_PRESSURE'
        Name = 'FACTOR_DRUM_SUPPLY_LINE_PRESSURE'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_FILTER_UNIT_FLUSHING_DIW'
        Name = 'FACTOR_FILTER_UNIT_FLUSHING_DIW'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_H2O2_DRUM_UNIT_EXHAUST'
        Name = 'FACTOR_H2O2_DRUM_UNIT_EXHAUST'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_H2O2_DRUM_UNIT_LINE_PRESSURE'
        Name = 'FACTOR_H2O2_DRUM_UNIT_LINE_PRESSURE'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_MAIN_CDA_TO_DRUM_DRAIN'
        Name = 'FACTOR_MAIN_CDA_TO_DRUM_DRAIN'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_MAIN_CDA_TO_H2O2_DRUM'
        Name = 'FACTOR_MAIN_CDA_TO_H2O2_DRUM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_MAIN_CDA_TO_TANKA'
        Name = 'FACTOR_MAIN_CDA_TO_TANKA'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_MAIN_CDA_TO_TANKB'
        Name = 'FACTOR_MAIN_CDA_TO_TANKB'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_MAIN_N2'
        Name = 'FACTOR_MAIN_N2'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_PCW_LINE_IN'
        Name = 'FACTOR_PCW_LINE_IN'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_PCW_LINE_OUT'
        Name = 'FACTOR_PCW_LINE_OUT'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_PURGE_N2_TO_FILTER'
        Name = 'FACTOR_PURGE_N2_TO_FILTER'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SEPARATOR_BOX_EXHAUST'
        Name = 'FACTOR_SEPARATOR_BOX_EXHAUST'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_13_FM'
        Name = 'FACTOR_SUPPLY_13_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_13_PS'
        Name = 'FACTOR_SUPPLY_13_PS'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_24_FM'
        Name = 'FACTOR_SUPPLY_24_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_24_PS'
        Name = 'FACTOR_SUPPLY_24_PS'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_57_FM'
        Name = 'FACTOR_SUPPLY_57_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_57_PS'
        Name = 'FACTOR_SUPPLY_57_PS'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_68_FM'
        Name = 'FACTOR_SUPPLY_68_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_SUPPLY_68_PS'
        Name = 'FACTOR_SUPPLY_68_PS'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_CHEM_DRUM_FM'
        Name = 'FACTOR_TANKA_CHEM_DRUM_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_DIW_FM'
        Name = 'FACTOR_TANKA_DIW_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_EXHAUST'
        Name = 'FACTOR_TANKA_EXHAUST'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_H2O2_CCSS_FM'
        Name = 'FACTOR_TANKA_H2O2_CCSS_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_H2O2_DRUM_FM'
        Name = 'FACTOR_TANKA_H2O2_DRUM_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_LASER_SENSOR'
        Name = 'FACTOR_TANKA_LASER_SENSOR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_N2_LINE_IN'
        Name = 'FACTOR_TANKA_N2_LINE_IN'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKA_TMAH_FM'
        Name = 'FACTOR_TANKA_TMAH_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_CHEM_DRUM_FM'
        Name = 'FACTOR_TANKB_CHEM_DRUM_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_DIW_FM'
        Name = 'FACTOR_TANKB_DIW_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_EXHAUST'
        Name = 'FACTOR_TANKB_EXHAUST'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_H2O2_CCSS_FM'
        Name = 'FACTOR_TANKB_H2O2_CCSS_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_H2O2_DRUM_FM'
        Name = 'FACTOR_TANKB_H2O2_DRUM_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_LASER_SENSOR'
        Name = 'FACTOR_TANKB_LASER_SENSOR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Analog'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_N2_LINE_IN'
        Name = 'FACTOR_TANKB_N2_LINE_IN'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup FlowMeter'
        DataType = dtDouble
        DisplayName = 'FACTOR_TANKB_TMAH_FM'
        Name = 'FACTOR_TANKB_TMAH_FM'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'FILTER_UNIT_FLUSHING_DIW_HI'
        Name = 'FILTER_UNIT_FLUSHING_DIW_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'FILTER_UNIT_FLUSHING_DIW_LO'
        Name = 'FILTER_UNIT_FLUSHING_DIW_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Communication'
        DisplayName = 'FLOW_METER_PORT'
        Name = 'FLOW_METER_PORT'
        Tag = 0
        Value = 0
        ZDescription = '0:COM1, 1:COM2'
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'H2O2_DRUM_UNIT_EXHAUST_HI'
        Name = 'H2O2_DRUM_UNIT_EXHAUST_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'H2O2_DRUM_UNIT_EXHAUST_LO'
        Name = 'H2O2_DRUM_UNIT_EXHAUST_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'H2O2_DRUM_UNIT_LINE_PRESSURE_HI'
        Name = 'H2O2_DRUM_UNIT_LINE_PRESSURE_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'H2O2_DRUM_UNIT_LINE_PRESSURE_LO'
        Name = 'H2O2_DRUM_UNIT_LINE_PRESSURE_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Communication'
        DisplayName = 'HANDLER_PORT'
        Name = 'HANDLER_PORT'
        Tag = 0
        Value = 4000
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'JOB_PATH'
        Name = 'JOB_PATH'
        Tag = 0
        Value = ''
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'LOG_PATH'
        Name = 'LOG_PATH'
        Tag = 0
        Value = ''
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'MACHINE_ID'
        Name = 'MACHINE_ID'
        Tag = 0
        Value = '1234'
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'MACHINE_NAME'
        Name = 'MACHINE_NAME'
        Tag = 0
        Value = 'VSTACKING'
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_DRUM_DRAIN_HI'
        Name = 'MAIN_CDA_TO_DRUM_DRAIN_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_DRUM_DRAIN_LO'
        Name = 'MAIN_CDA_TO_DRUM_DRAIN_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_H2O2_DRUM_HI'
        Name = 'MAIN_CDA_TO_H2O2_DRUM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_H2O2_DRUM_LO'
        Name = 'MAIN_CDA_TO_H2O2_DRUM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_TANKA_HI'
        Name = 'MAIN_CDA_TO_TANKA_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_TANKA_LO'
        Name = 'MAIN_CDA_TO_TANKA_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_TANKB_HI'
        Name = 'MAIN_CDA_TO_TANKB_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_TANKB_LO'
        Name = 'MAIN_CDA_TO_TANKB_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_N2_HI'
        Name = 'MAIN_N2_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_N2_LO'
        Name = 'MAIN_N2_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'PCW_LINE_IN_HI'
        Name = 'PCW_LINE_IN_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'PCW_LINE_IN_LO'
        Name = 'PCW_LINE_IN_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'PCW_LINE_OUT_HI'
        Name = 'PCW_LINE_OUT_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'PCW_LINE_OUT_LO'
        Name = 'PCW_LINE_OUT_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'PRODUCT_LOG_FILE_NAME'
        Name = 'PRODUCT_LOG_FILE_NAME'
        Tag = 0
        Value = '%YEAR%%MONTH%%DAY%-UP.CSV'
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'PRODUCT_LOG_FILE_PATH'
        Name = 'PRODUCT_LOG_FILE_PATH'
        Tag = 0
        Value = 'D:\DATA\'
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'PURGE_N2_TO_FILTER_HI'
        Name = 'PURGE_N2_TO_FILTER_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'PURGE_N2_TO_FILTER_LO'
        Name = 'PURGE_N2_TO_FILTER_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Report'
        DisplayName = 'REPORT_SAVE_INTERVAL_MINUTES'
        Min = 1.000000000000000000
        Max = 1440.000000000000000000
        Name = 'REPORT_SAVE_INTERVAL_MINUTES'
        Tag = 0
        Value = 30
        ZDescription = 'Report save interval in minutes'
      end
      item
        Category = 'Communication'
        DataType = dtString
        DisplayName = 'SAFETY_ADDRESS'
        Name = 'SAFETY_ADDRESS'
        Tag = 0
        Value = '127.0.0.1'
      end
      item
        Category = 'Communication'
        DataType = dtString
        DisplayName = 'SAFETY_PORT'
        Name = 'SAFETY_PORT'
        Tag = 0
        Value = '502'
      end
      item
        Category = 'General'
        DataType = dtString
        DisplayName = 'SAVE_IMAGE_TYPE'
        Name = 'SAVE_IMAGE_TYPE'
        Tag = 0
        Value = '.jpg'
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SEPARATOR_BOX_EXHAUST_HI'
        Name = 'SEPARATOR_BOX_EXHAUST_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SEPARATOR_BOX_EXHAUST_LO'
        Name = 'SEPARATOR_BOX_EXHAUST_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Recipe'
        DisplayName = 'SETUP_CLEAN_COUNT'
        Name = 'SETUP_CLEAN_COUNT'
        Tag = 0
        Value = 3
      end
      item
        Category = 'Setup Recipe Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_DRAIN_TANK_DRAIN_ENABLE_TEMP'
        Name = 'SETUP_DRAIN_TANK_DRAIN_ENABLE_TEMP'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Setup Recipe'
        DataType = dtDouble
        DisplayName = 'SETUP_SUPPLY_ADD_CAPA'
        Name = 'SETUP_SUPPLY_ADD_CAPA'
        Tag = 0
        Value = 10.000000000000000000
      end
      item
        Category = 'Setup Recipe'
        DataType = dtDouble
        DisplayName = 'SETUP_SUPPLY_CAPA'
        Name = 'SETUP_SUPPLY_CAPA'
        Tag = 0
        Value = 200.000000000000000000
      end
      item
        Category = 'Setup Recipe'
        DataType = dtDouble
        DisplayName = 'SETUP_SUPPLY_CHEM_PERCENT'
        Name = 'SETUP_SUPPLY_CHEM_PERCENT'
        Tag = 0
        Value = 19.000000000000000000
      end
      item
        Category = 'Setup Recipe'
        DataType = dtDouble
        DisplayName = 'SETUP_SUPPLY_CHEM2_PERCENT'
        Name = 'SETUP_SUPPLY_CHEM2_PERCENT'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Setup Recipe Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TANK_CONC_SET'
        Name = 'SETUP_TANK_CONC_SET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Setup Recipe Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TANK_CONC_TORR'
        Name = 'SETUP_TANK_CONC_TORR'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Setup Recipe Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TANK_TEMP_SET'
        Name = 'SETUP_TANK_TEMP_SET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Setup Recipe Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TANK_TEMP_TORR'
        Name = 'SETUP_TANK_TEMP_TORR'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_DRAIN1'
        Name = 'SETUP_TC_DRAIN1'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_DRAIN2'
        Name = 'SETUP_TC_DRAIN2'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_1_CONTROL'
        Name = 'SETUP_TC_TANKA_1_CONTROL'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_1_INTERLOCK1'
        Name = 'SETUP_TC_TANKA_1_INTERLOCK1'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_1_INTERLOCK2'
        Name = 'SETUP_TC_TANKA_1_INTERLOCK2'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_1_TANK'
        Name = 'SETUP_TC_TANKA_1_TANK'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_2_CONTROL'
        Name = 'SETUP_TC_TANKA_2_CONTROL'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_2_INTERLOCK1'
        Name = 'SETUP_TC_TANKA_2_INTERLOCK1'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_2_INTERLOCK2'
        Name = 'SETUP_TC_TANKA_2_INTERLOCK2'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKA_2_TANK'
        Name = 'SETUP_TC_TANKA_2_TANK'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_1_CONTROL'
        Name = 'SETUP_TC_TANKB_1_CONTROL'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_1_INTERLOCK1'
        Name = 'SETUP_TC_TANKB_1_INTERLOCK1'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_1_INTERLOCK2'
        Name = 'SETUP_TC_TANKB_1_INTERLOCK2'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_1_TANK'
        Name = 'SETUP_TC_TANKB_1_TANK'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_2_CONTROL'
        Name = 'SETUP_TC_TANKB_2_CONTROL'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_2_INTERLOCK1'
        Name = 'SETUP_TC_TANKB_2_INTERLOCK1'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_2_INTERLOCK2'
        Name = 'SETUP_TC_TANKB_2_INTERLOCK2'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Setup Temp'
        DataType = dtDouble
        DisplayName = 'SETUP_TC_TANKB_2_TANK'
        Name = 'SETUP_TC_TANKB_2_TANK'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Start-Up'
        DataType = dtBoolean
        DisplayName = 'STARTUP_WITH_HW'
        Name = 'STARTUP_WITH_HW'
        Tag = 0
        Value = False
      end
      item
        Category = 'Start-Up'
        DisplayName = 'STARTUP_WITH_MACHINE_KIND'
        Name = 'STARTUP_WITH_MACHINE_KIND'
        Tag = 0
        Value = 0
        ZDescription = '0:TI, 1:CU'
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_13_FM_HI'
        Name = 'SUPPLY_13_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_13_FM_LO'
        Name = 'SUPPLY_13_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_13_PS_HI'
        Name = 'SUPPLY_13_PS_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_13_PS_LO'
        Name = 'SUPPLY_13_PS_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_24_FM_HI'
        Name = 'SUPPLY_24_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_24_FM_LO'
        Name = 'SUPPLY_24_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_24_PS_HI'
        Name = 'SUPPLY_24_PS_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_24_PS_LO'
        Name = 'SUPPLY_24_PS_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_57_FM_HI'
        Name = 'SUPPLY_57_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_57_FM_LO'
        Name = 'SUPPLY_57_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_57_PS_HI'
        Name = 'SUPPLY_57_PS_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_57_PS_LO'
        Name = 'SUPPLY_57_PS_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_68_FM_HI'
        Name = 'SUPPLY_68_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_68_FM_LO'
        Name = 'SUPPLY_68_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_68_PS_HI'
        Name = 'SUPPLY_68_PS_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_68_PS_LO'
        Name = 'SUPPLY_68_PS_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_CHEM_DRUM_FM_HI'
        Name = 'TANKA_CHEM_DRUM_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_CHEM_DRUM_FM_LO'
        Name = 'TANKA_CHEM_DRUM_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_DIW_CCSS_FM_HI'
        Name = 'TANKA_DIW_CCSS_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_DIW_CCSS_FM_LO'
        Name = 'TANKA_DIW_CCSS_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_EXHAUST_HI'
        Name = 'TANKA_EXHAUST_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_EXHAUST_LO'
        Name = 'TANKA_EXHAUST_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_H2O2_CCSS_FM_HI'
        Name = 'TANKA_H2O2_CCSS_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_H2O2_CCSS_FM_LO'
        Name = 'TANKA_H2O2_CCSS_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_H2O2_DRUM_FM_HI'
        Name = 'TANKA_H2O2_DRUM_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_H2O2_DRUM_FM_LO'
        Name = 'TANKA_H2O2_DRUM_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_LASER_SENSOR_HI'
        Name = 'TANKA_LASER_SENSOR_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_LASER_SENSOR_LO'
        Name = 'TANKA_LASER_SENSOR_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_N2_LINE_IN_HI'
        Name = 'TANKA_N2_LINE_IN_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_N2_LINE_IN_LO'
        Name = 'TANKA_N2_LINE_IN_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_CHEM_DRUM_FM_HI'
        Name = 'TANKB_CHEM_DRUM_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_CHEM_DRUM_FM_LO'
        Name = 'TANKB_CHEM_DRUM_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_DIW_CCSS_FM_HI'
        Name = 'TANKB_DIW_CCSS_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_DIW_CCSS_FM_LO'
        Name = 'TANKB_DIW_CCSS_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_EXHAUST_HI'
        Name = 'TANKB_EXHAUST_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_EXHAUST_LO'
        Name = 'TANKB_EXHAUST_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_H2O2_CCSS_FM_HI'
        Name = 'TANKB_H2O2_CCSS_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_H2O2_CCSS_FM_LO'
        Name = 'TANKB_H2O2_CCSS_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_H2O2_DRUM_FM_HI'
        Name = 'TANKB_H2O2_DRUM_FM_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_H2O2_DRUM_FM_LO'
        Name = 'TANKB_H2O2_DRUM_FM_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_LASER_SENSOR_HI'
        Name = 'TANKB_LASER_SENSOR_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_LASER_SENSOR_LO'
        Name = 'TANKB_LASER_SENSOR_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_N2_LINE_IN_HI'
        Name = 'TANKB_N2_LINE_IN_HI'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_N2_LINE_IN_LO'
        Name = 'TANKB_N2_LINE_IN_LO'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_DRAIN1_HI'
        Name = 'TC_DRAIN1_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_DRAIN1_LO'
        Name = 'TC_DRAIN1_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_DRAIN2_HI'
        Name = 'TC_DRAIN2_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_DRAIN2_LO'
        Name = 'TC_DRAIN2_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_CONTROL_HI'
        Name = 'TC_TANKA_1_CONTROL_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_CONTROL_LO'
        Name = 'TC_TANKA_1_CONTROL_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_INTERLOCK1_HI'
        Name = 'TC_TANKA_1_INTERLOCK1_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_INTERLOCK1_LO'
        Name = 'TC_TANKA_1_INTERLOCK1_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_INTERLOCK2_HI'
        Name = 'TC_TANKA_1_INTERLOCK2_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_INTERLOCK2_LO'
        Name = 'TC_TANKA_1_INTERLOCK2_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_TANK_HI'
        Name = 'TC_TANKA_1_TANK_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_TANK_LO'
        Name = 'TC_TANKA_1_TANK_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_CONTROL_HI'
        Name = 'TC_TANKA_2_CONTROL_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_CONTROL_LO'
        Name = 'TC_TANKA_2_CONTROL_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_INTERLOCK1_HI'
        Name = 'TC_TANKA_2_INTERLOCK1_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_INTERLOCK1_LO'
        Name = 'TC_TANKA_2_INTERLOCK1_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_INTERLOCK2_HI'
        Name = 'TC_TANKA_2_INTERLOCK2_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_INTERLOCK2_LO'
        Name = 'TC_TANKA_2_INTERLOCK2_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_TANK_HI'
        Name = 'TC_TANKA_2_TANK_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_TANK_LO'
        Name = 'TC_TANKA_2_TANK_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_CONTROL_HI'
        Name = 'TC_TANKB_1_CONTROL_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_CONTROL_LO'
        Name = 'TC_TANKB_1_CONTROL_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_INTERLOCK1_HI'
        Name = 'TC_TANKB_1_INTERLOCK1_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_INTERLOCK1_LO'
        Name = 'TC_TANKB_1_INTERLOCK1_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_INTERLOCK2_HI'
        Name = 'TC_TANKB_1_INTERLOCK2_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_INTERLOCK2_LO'
        Name = 'TC_TANKB_1_INTERLOCK2_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_TANK_HI'
        Name = 'TC_TANKB_1_TANK_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_TANK_LO'
        Name = 'TC_TANKB_1_TANK_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_CONTROL_HI'
        Name = 'TC_TANKB_2_CONTROL_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_CONTROL_LO'
        Name = 'TC_TANKB_2_CONTROL_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_INTERLOCK1_HI'
        Name = 'TC_TANKB_2_INTERLOCK1_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_INTERLOCK1_LO'
        Name = 'TC_TANKB_2_INTERLOCK1_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_INTERLOCK2_HI'
        Name = 'TC_TANKB_2_INTERLOCK2_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_INTERLOCK2_LO'
        Name = 'TC_TANKB_2_INTERLOCK2_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_TANK_HI'
        Name = 'TC_TANKB_2_TANK_HI'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Spec Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_TANK_LO'
        Name = 'TC_TANKB_2_TANK_LO'
        Tag = 0
        Value = 30.000000000000000000
      end
      item
        Category = 'Communication'
        DisplayName = 'TEMP_CONTROL_PORT'
        Name = 'TEMP_CONTROL_PORT'
        Tag = 0
        Value = 0
        ZDescription = '0:COM1, 1:COM2'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_AUTO_CLEAN_TIME'
        Name = 'TMR_AUTO_CLEAN_TIME'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_CHEM_DRUM_SUPPLY_TIMEOUT'
        Name = 'TMR_CHEM_DRUM_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 10.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_DRAIN_LEVEL_DELAY'
        Name = 'TMR_DRAIN_LEVEL_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_DRAIN_PUMP_CS_DELAY'
        Name = 'TMR_DRAIN_PUMP_CS_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_DRAIN_PUMP_OFF_DELAY'
        Name = 'TMR_DRAIN_PUMP_OFF_DELAY'
        Tag = 0
        Value = 1.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_DRAIN_PUMP_ON_DELAY'
        Name = 'TMR_DRAIN_PUMP_ON_DELAY'
        Tag = 0
        Value = 1.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_DRAIN_PUMP_ONOFF_TIMEOUT'
        Name = 'TMR_DRAIN_PUMP_ONOFF_TIMEOUT'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_DRAIN_TOTAL_TIMEOUT'
        Name = 'TMR_DRAIN_TOTAL_TIMEOUT'
        Tag = 0
        Value = 500.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_FILTER_VENT_INTERVAL'
        Name = 'TMR_FILTER_VENT_INTERVAL'
        Tag = 0
        Value = 1000.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_FILTER_VENT_TIME'
        Name = 'TMR_FILTER_VENT_TIME'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_H2O2_DRUM_SUPPLY_TIMEOUT'
        Name = 'TMR_H2O2_DRUM_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 10.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_LEAK_OFF_DELAY'
        Name = 'TMR_LEAK_OFF_DELAY'
        Tag = 0
        Value = 0.100000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_LEAK_ON_DELAY'
        Name = 'TMR_LEAK_ON_DELAY'
        Tag = 0
        Value = 0.100000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_OVER_OFF_DELAY'
        Name = 'TMR_OVER_OFF_DELAY'
        Tag = 0
        Value = 0.100000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_OVER_ON_DELAY'
        Name = 'TMR_OVER_ON_DELAY'
        Tag = 0
        Value = 0.100000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_CHEM_SUPPLY_LIFE_TIME'
        Name = 'TMR_TANKA_CHEM_SUPPLY_LIFE_TIME'
        Tag = 0
        Value = 5000.000000000000000000
        ZDescription = 'min'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_CHEM_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKA_CHEM_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_CONC_CHECK_NG'
        Name = 'TMR_TANKA_CONC_CHECK_NG'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_CONC_CHECK_OK'
        Name = 'TMR_TANKA_CONC_CHECK_OK'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_CONC_CHECK_TIMEOUT'
        Name = 'TMR_TANKA_CONC_CHECK_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_DIWCCSS_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKA_DIWCCSS_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_DRAIN_DELAY'
        Name = 'TMR_TANKA_DRAIN_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_DRAIN_TIMEOUT'
        Name = 'TMR_TANKA_DRAIN_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_H2O2_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKA_H2O2_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_H2O2CCSS_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKA_H2O2CCSS_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_LEVEL_DELAY'
        Name = 'TMR_TANKA_LEVEL_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_MIX_START_DEALY'
        Name = 'TMR_TANKA_MIX_START_DEALY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_PUMP_CS_DELAY'
        Name = 'TMR_TANKA_PUMP_CS_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_PUMP_OFF_DELAY'
        Name = 'TMR_TANKA_PUMP_OFF_DELAY'
        Tag = 0
        Value = 1.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_PUMP_ON_DELAY'
        Name = 'TMR_TANKA_PUMP_ON_DELAY'
        Tag = 0
        Value = 1.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_PUMP_ONOFF_TIMEOUT'
        Name = 'TMR_TANKA_PUMP_ONOFF_TIMEOUT'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_TEMP_CHECK_NG'
        Name = 'TMR_TANKA_TEMP_CHECK_NG'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_TEMP_CHECK_OK'
        Name = 'TMR_TANKA_TEMP_CHECK_OK'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_TEMP_CHECK_TIMEOUT'
        Name = 'TMR_TANKA_TEMP_CHECK_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKA_TMAHCCSS_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKA_TMAHCCSS_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_CHEM_SUPPLY_LIFE_TIME'
        Name = 'TMR_TANKB_CHEM_SUPPLY_LIFE_TIME'
        Tag = 0
        Value = 5000.000000000000000000
        ZDescription = 'min'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_CHEM_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKB_CHEM_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_CONC_CHECK_NG'
        Name = 'TMR_TANKB_CONC_CHECK_NG'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_CONC_CHECK_OK'
        Name = 'TMR_TANKB_CONC_CHECK_OK'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_CONC_CHECK_TIMEOUT'
        Name = 'TMR_TANKB_CONC_CHECK_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_DIWCCSS_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKB_DIWCCSS_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_DRAIN_DELAY'
        Name = 'TMR_TANKB_DRAIN_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_DRAIN_TIMEOUT'
        Name = 'TMR_TANKB_DRAIN_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_H2O2_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKB_H2O2_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_H2O2CCSS_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKB_H2O2CCSS_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_LEVEL_DELAY'
        Name = 'TMR_TANKB_LEVEL_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_MIX_START_DEALY'
        Name = 'TMR_TANKB_MIX_START_DEALY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_PUMP_CS_DELAY'
        Name = 'TMR_TANKB_PUMP_CS_DELAY'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_PUMP_OFF_DELAY'
        Name = 'TMR_TANKB_PUMP_OFF_DELAY'
        Tag = 0
        Value = 1.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_PUMP_ON_DELAY'
        Name = 'TMR_TANKB_PUMP_ON_DELAY'
        Tag = 0
        Value = 1.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_PUMP_ONOFF_TIMEOUT'
        Name = 'TMR_TANKB_PUMP_ONOFF_TIMEOUT'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_TEMP_CHECK_NG'
        Name = 'TMR_TANKB_TEMP_CHECK_NG'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_TEMP_CHECK_OK'
        Name = 'TMR_TANKB_TEMP_CHECK_OK'
        Tag = 0
        Value = 5.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_TEMP_CHECK_TIMEOUT'
        Name = 'TMR_TANKB_TEMP_CHECK_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Timer'
        DataType = dtDouble
        DisplayName = 'TMR_TANKB_TMAHCCSS_SUPPLY_TIMEOUT'
        Name = 'TMR_TANKB_TMAHCCSS_SUPPLY_TIMEOUT'
        Tag = 0
        Value = 100.000000000000000000
        ZDescription = 'sec'
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_ALWAYS_LOGIN'
        Name = 'USE_ALWAYS_LOGIN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_CHEM_BARCODE'
        Name = 'USE_CHEM_BARCODE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_H2O2_BARCODE'
        Name = 'USE_H2O2_BARCODE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_H2O2_DRUM'
        Name = 'USE_H2O2_DRUM'
        Tag = 0
        Value = True
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_IDLE_RUINNING'
        Name = 'USE_IDLE_RUINNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_IGNORE_DOOR_ALARM'
        Name = 'USE_IGNORE_DOOR_ALARM'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_IGNORE_LEAK_DETECT'
        Name = 'USE_IGNORE_LEAK_DETECT'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_IGNORE_OVER_DETECT'
        Name = 'USE_IGNORE_OVER_DETECT'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_SAVE_ALL_VISION'
        Name = 'USE_SAVE_ALL_VISION'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_SAVE_NG_VISION'
        Name = 'USE_SAVE_NG_VISION'
        Tag = 0
        Value = False
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_SUPPLY_13'
        Name = 'USE_SUPPLY_13'
        Tag = 0
        Value = True
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_SUPPLY_24'
        Name = 'USE_SUPPLY_24'
        Tag = 0
        Value = True
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_SUPPLY_57'
        Name = 'USE_SUPPLY_57'
        Tag = 0
        Value = True
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_SUPPLY_68'
        Name = 'USE_SUPPLY_68'
        Tag = 0
        Value = True
      end
      item
        Category = 'Option'
        DataType = dtBoolean
        DisplayName = 'USE_VIRTUAL_RUINNING'
        Name = 'USE_VIRTUAL_RUINNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'WMX'
        DisplayName = 'WMX_CONNECT_RETRY'
        Name = 'WMX_CONNECT_RETRY'
        Tag = 0
        Value = 10
      end>
    ChannelPrefix = 'S_'
    SimulateItems = <>
    OnChannelChanged = SysServerChannelChanged
    Left = 56
    Top = 84
  end
  object IOServer: TfoDataServer
    OnChanged = IOServerChanged
    OnError = DataServerError
    Channels = <
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = '70_VAL'
        Name = '70_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = '72_VAL'
        Name = '72_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = '74_VAL'
        Name = '74_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = '84_VAL'
        Name = '84_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'ACTIVE_JOB'
        Name = 'ACTIVE_JOB'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_ALL_DOOR_LOCK'
        Name = 'AUTO_ALL_DOOR_LOCK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DisplayName = 'AUTO_COMMAND'
        Name = 'AUTO_COMMAND'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_COMMAND_USE_TANKA'
        Name = 'AUTO_COMMAND_USE_TANKA'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_COMMAND_USE_TANKB'
        Name = 'AUTO_COMMAND_USE_TANKB'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DisplayName = 'AUTO_CURRENT_STEP'
        Name = 'AUTO_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto'
        DataType = dtString
        DisplayName = 'AUTO_CURRENT_STEP_NAME'
        Name = 'AUTO_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_INITIALIZE'
        Name = 'AUTO_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_INITIALIZE_OK'
        Name = 'AUTO_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_MANUAL'
        Name = 'AUTO_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_RESET_BTN'
        Name = 'AUTO_RESET_BTN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_RESET_BTN'
        Name = 'AUTO_RESET_BTN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status System'
        DisplayName = 'AUTO_RUN_TYPE'
        Name = 'AUTO_RUN_TYPE'
        Tag = 0
        Value = 0
        ZDescription = 
          '0 : NORMAL RUN, 1 : TEST, 2 : CALIBRATE, 3 : MAINTENANCE, 4 : R&' +
          'R'
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'AUTO_RUN_TYPE_CAPTION'
        Name = 'AUTO_RUN_TYPE_CAPTION'
        Tag = 0
        Value = 'NORMAL RUN'
        ZDescription = 
          '0 : NORMAL RUN, 1 : TEST, 2 : CALIBRATE, 3 : MAINTENANCE, 4 : R&' +
          'R'
      end
      item
        Category = 'Status Auto'
        DataType = dtBoolean
        DisplayName = 'AUTO_RUNNING'
        Name = 'AUTO_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanA'
        DisplayName = 'AUTOCLEANA_CLEAN_NO'
        Name = 'AUTOCLEANA_CLEAN_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto CleanA'
        DisplayName = 'AUTOCLEANA_CURRENT_STEP'
        Name = 'AUTOCLEANA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto CleanA'
        DataType = dtString
        DisplayName = 'AUTOCLEANA_CURRENT_STEP_NAME'
        Name = 'AUTOCLEANA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto CleanA'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANA_INITIALIZE'
        Name = 'AUTOCLEANA_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanA'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANA_INITIALIZE_OK'
        Name = 'AUTOCLEANA_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanA'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANA_MANUAL'
        Name = 'AUTOCLEANA_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanA'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANA_RUNNING'
        Name = 'AUTOCLEANA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanA'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANA_TIME_ONOFF'
        Name = 'AUTOCLEANA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanB'
        DisplayName = 'AUTOCLEANB_CLEAN_NO'
        Name = 'AUTOCLEANB_CLEAN_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto CleanB'
        DisplayName = 'AUTOCLEANB_CURRENT_STEP'
        Name = 'AUTOCLEANB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto CleanB'
        DataType = dtString
        DisplayName = 'AUTOCLEANB_CURRENT_STEP_NAME'
        Name = 'AUTOCLEANB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto CleanB'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANB_INITIALIZE'
        Name = 'AUTOCLEANB_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanB'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANB_INITIALIZE_OK'
        Name = 'AUTOCLEANB_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanB'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANB_MANUAL'
        Name = 'AUTOCLEANB_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanB'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANB_RUNNING'
        Name = 'AUTOCLEANB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto CleanB'
        DataType = dtBoolean
        DisplayName = 'AUTOCLEANB_TIME_ONOFF'
        Name = 'AUTOCLEANB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DisplayName = 'AUTOCONCA_CURRENT_STEP'
        Name = 'AUTOCONCA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtString
        DisplayName = 'AUTOCONCA_CURRENT_STEP_NAME'
        Name = 'AUTOCONCA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_INITIALIZE'
        Name = 'AUTOCONCA_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_INITIALIZE_OK'
        Name = 'AUTOCONCA_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_MANUAL'
        Name = 'AUTOCONCA_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_OFF_TIME_ONOFF'
        Name = 'AUTOCONCA_OFF_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtDouble
        DisplayName = 'AUTOCONCA_OFF_TIMER'
        Name = 'AUTOCONCA_OFF_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_ON_TIME_ONOFF'
        Name = 'AUTOCONCA_ON_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtDouble
        DisplayName = 'AUTOCONCA_ON_TIMER'
        Name = 'AUTOCONCA_ON_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_RUNNING'
        Name = 'AUTOCONCA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCA_TIME_ONOFF'
        Name = 'AUTOCONCA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcA'
        DataType = dtDouble
        DisplayName = 'AUTOCONCA_TIMER'
        Name = 'AUTOCONCA_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto ConcB'
        DisplayName = 'AUTOCONCB_CURRENT_STEP'
        Name = 'AUTOCONCB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtString
        DisplayName = 'AUTOCONCB_CURRENT_STEP_NAME'
        Name = 'AUTOCONCB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_INITIALIZE'
        Name = 'AUTOCONCB_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_INITIALIZE_OK'
        Name = 'AUTOCONCB_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_MANUAL'
        Name = 'AUTOCONCB_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_OFF_TIME_ONOFF'
        Name = 'AUTOCONCB_OFF_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtDouble
        DisplayName = 'AUTOCONCB_OFF_TIMER'
        Name = 'AUTOCONCB_OFF_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_ON_TIME_ONOFF'
        Name = 'AUTOCONCB_ON_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtDouble
        DisplayName = 'AUTOCONCB_ON_TIMER'
        Name = 'AUTOCONCB_ON_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_RUNNING'
        Name = 'AUTOCONCB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtBoolean
        DisplayName = 'AUTOCONCB_TIME_ONOFF'
        Name = 'AUTOCONCB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto ConcB'
        DataType = dtDouble
        DisplayName = 'AUTOCONCB_TIMER'
        Name = 'AUTOCONCB_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto Drain'
        DisplayName = 'AUTODRAIN_CURRENT_STEP'
        Name = 'AUTODRAIN_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtString
        DisplayName = 'AUTODRAIN_CURRENT_STEP_NAME'
        Name = 'AUTODRAIN_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_DRAIN_RUN'
        Name = 'AUTODRAIN_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_DRAIN_TIME_ONOFF'
        Name = 'AUTODRAIN_DRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtDouble
        DisplayName = 'AUTODRAIN_DRAIN_TIMER'
        Name = 'AUTODRAIN_DRAIN_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_INITIALIZE'
        Name = 'AUTODRAIN_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_INITIALIZE_OK'
        Name = 'AUTODRAIN_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_MANUAL'
        Name = 'AUTODRAIN_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_RUNNING'
        Name = 'AUTODRAIN_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto Drain'
        DataType = dtBoolean
        DisplayName = 'AUTODRAIN_TIME_ONOFF'
        Name = 'AUTODRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_CHEM_SUPPLY_CHEANGE'
        Name = 'AUTOTANKA_CHEM_SUPPLY_CHEANGE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtDouble
        DisplayName = 'AUTOTANKA_CHEM_SUPPLY_LIFE_TIMER'
        Name = 'AUTOTANKA_CHEM_SUPPLY_LIFE_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_CONC_OK'
        Name = 'AUTOTANKA_CONC_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_CONC_RUN'
        Name = 'AUTOTANKA_CONC_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DisplayName = 'AUTOTANKA_CURRENT_STEP'
        Name = 'AUTOTANKA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtString
        DisplayName = 'AUTOTANKA_CURRENT_STEP_NAME'
        Name = 'AUTOTANKA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_DRAIN_TIME_ONOFF'
        Name = 'AUTOTANKA_DRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtDouble
        DisplayName = 'AUTOTANKA_DRAIN_TIMER'
        Name = 'AUTOTANKA_DRAIN_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TankA'
        DisplayName = 'AUTOTANKA_EXEC_COMMAND'
        Name = 'AUTOTANKA_EXEC_COMMAND'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_INITIALIZE'
        Name = 'AUTOTANKA_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_INITIALIZE_OK'
        Name = 'AUTOTANKA_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_LOCAL_CIR_RUN'
        Name = 'AUTOTANKA_LOCAL_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_MAIN_CIR_RUN'
        Name = 'AUTOTANKA_MAIN_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_MANUAL'
        Name = 'AUTOTANKA_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_MIX_START_TIME_ONOFF'
        Name = 'AUTOTANKA_MIX_START_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtDouble
        DisplayName = 'AUTOTANKA_MIX_START_TIMER'
        Name = 'AUTOTANKA_MIX_START_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_RUNNING'
        Name = 'AUTOTANKA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_TEMP_OK'
        Name = 'AUTOTANKA_TEMP_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_TEMP_RUN'
        Name = 'AUTOTANKA_TEMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankA'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKA_TIME_ONOFF'
        Name = 'AUTOTANKA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_CHEM_SUPPLY_CHEANGE'
        Name = 'AUTOTANKB_CHEM_SUPPLY_CHEANGE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtDouble
        DisplayName = 'AUTOTANKB_CHEM_SUPPLY_LIFE_TIMER'
        Name = 'AUTOTANKB_CHEM_SUPPLY_LIFE_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_CONC_OK'
        Name = 'AUTOTANKB_CONC_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_CONC_RUN'
        Name = 'AUTOTANKB_CONC_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DisplayName = 'AUTOTANKB_CURRENT_STEP'
        Name = 'AUTOTANKB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtString
        DisplayName = 'AUTOTANKB_CURRENT_STEP_NAME'
        Name = 'AUTOTANKB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_DRAIN_TIME_ONOFF'
        Name = 'AUTOTANKB_DRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtDouble
        DisplayName = 'AUTOTANKB_DRAIN_TIMER'
        Name = 'AUTOTANKB_DRAIN_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TankB'
        DisplayName = 'AUTOTANKB_EXEC_COMMAND'
        Name = 'AUTOTANKB_EXEC_COMMAND'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_INITIALIZE'
        Name = 'AUTOTANKB_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_INITIALIZE_OK'
        Name = 'AUTOTANKB_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_LOCAL_CIR_RUN'
        Name = 'AUTOTANKB_LOCAL_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_MAIN_CIR_RUN'
        Name = 'AUTOTANKB_MAIN_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_MANUAL'
        Name = 'AUTOTANKB_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_MIX_START_TIME_ONOFF'
        Name = 'AUTOTANKB_MIX_START_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtDouble
        DisplayName = 'AUTOTANKB_MIX_START_TIMER'
        Name = 'AUTOTANKB_MIX_START_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_RUNNING'
        Name = 'AUTOTANKB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_TEMP_OK'
        Name = 'AUTOTANKB_TEMP_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_TEMP_RUN'
        Name = 'AUTOTANKB_TEMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TankB'
        DataType = dtBoolean
        DisplayName = 'AUTOTANKB_TIME_ONOFF'
        Name = 'AUTOTANKB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DisplayName = 'AUTOTEMPA_CURRENT_STEP'
        Name = 'AUTOTEMPA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtString
        DisplayName = 'AUTOTEMPA_CURRENT_STEP_NAME'
        Name = 'AUTOTEMPA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_INITIALIZE'
        Name = 'AUTOTEMPA_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_INITIALIZE_OK'
        Name = 'AUTOTEMPA_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_MANUAL'
        Name = 'AUTOTEMPA_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_OFF_TIME_ONOFF'
        Name = 'AUTOTEMPA_OFF_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtDouble
        DisplayName = 'AUTOTEMPA_OFF_TIMER'
        Name = 'AUTOTEMPA_OFF_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_ON_TIME_ONOFF'
        Name = 'AUTOTEMPA_ON_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtDouble
        DisplayName = 'AUTOTEMPA_ON_TIMER'
        Name = 'AUTOTEMPA_ON_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_RUNNING'
        Name = 'AUTOTEMPA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPA_TIME_ONOFF'
        Name = 'AUTOTEMPA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempA'
        DataType = dtDouble
        DisplayName = 'AUTOTEMPA_TIMER'
        Name = 'AUTOTEMPA_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TempB'
        DisplayName = 'AUTOTEMPB_CURRENT_STEP'
        Name = 'AUTOTEMPB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtString
        DisplayName = 'AUTOTEMPB_CURRENT_STEP_NAME'
        Name = 'AUTOTEMPB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_INITIALIZE'
        Name = 'AUTOTEMPB_INITIALIZE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_INITIALIZE_OK'
        Name = 'AUTOTEMPB_INITIALIZE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_MANUAL'
        Name = 'AUTOTEMPB_MANUAL'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_OFF_TIME_ONOFF'
        Name = 'AUTOTEMPB_OFF_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtDouble
        DisplayName = 'AUTOTEMPB_OFF_TIMER'
        Name = 'AUTOTEMPB_OFF_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_ON_TIME_ONOFF'
        Name = 'AUTOTEMPB_ON_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtDouble
        DisplayName = 'AUTOTEMPB_ON_TIMER'
        Name = 'AUTOTEMPB_ON_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_RUNNING'
        Name = 'AUTOTEMPB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtBoolean
        DisplayName = 'AUTOTEMPB_TIME_ONOFF'
        Name = 'AUTOTEMPB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Auto TempB'
        DataType = dtDouble
        DisplayName = 'AUTOTEMPB_TIMER'
        Name = 'AUTOTEMPB_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'System Status'
        DataType = dtBoolean
        DisplayName = 'BLINK_EMG_STOP'
        Name = 'BLINK_EMG_STOP'
        Tag = 0
        Value = False
      end
      item
        Category = 'System Status'
        DataType = dtBoolean
        DisplayName = 'BLINK_SW'
        Name = 'BLINK_SW'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrum'
        DisplayName = 'CHEMDRUM_CURRENT_STEP'
        Name = 'CHEMDRUM_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemDrum'
        DataType = dtString
        DisplayName = 'CHEMDRUM_CURRENT_STEP_NAME'
        Name = 'CHEMDRUM_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status ChemDrum'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUM_OVER_RUN'
        Name = 'CHEMDRUM_OVER_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrum'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUM_RUNNING'
        Name = 'CHEMDRUM_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrum'
        DisplayName = 'CHEMDRUM_TANK_NO'
        Name = 'CHEMDRUM_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemDrum'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUM_TIME_ONOFF'
        Name = 'CHEMDRUM_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrumSel'
        DisplayName = 'CHEMDRUMSEL_CHANGE_DRUM_NO'
        Name = 'CHEMDRUMSEL_CHANGE_DRUM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemDrumSel'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUMSEL_CHANGE_RUN'
        Name = 'CHEMDRUMSEL_CHANGE_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrumSel'
        DisplayName = 'CHEMDRUMSEL_CURRENT_STEP'
        Name = 'CHEMDRUMSEL_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemDrumSel'
        DataType = dtString
        DisplayName = 'CHEMDRUMSEL_CURRENT_STEP_NAME'
        Name = 'CHEMDRUMSEL_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status ChemDrumSel'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUMSEL_SEND_DATA_TO_HOST'
        Name = 'CHEMDRUMSEL_SEND_DATA_TO_HOST'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrumSel'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUMSEL_SEND_DATA_TO_HOST_OK'
        Name = 'CHEMDRUMSEL_SEND_DATA_TO_HOST_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrumSel'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUMSEL_STATUS_PUMP_RUN'
        Name = 'CHEMDRUMSEL_STATUS_PUMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemDrumSel'
        DataType = dtBoolean
        DisplayName = 'CHEMDRUMSEL_TIME_ONOFF'
        Name = 'CHEMDRUMSEL_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemSupplyA'
        DisplayName = 'CHEMSUPPLYA_CURRENT_STEP'
        Name = 'CHEMSUPPLYA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemSupplyA'
        DataType = dtString
        DisplayName = 'CHEMSUPPLYA_CURRENT_STEP_NAME'
        Name = 'CHEMSUPPLYA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status ChemSupplyA'
        DataType = dtBoolean
        DisplayName = 'CHEMSUPPLYA_RUNNING'
        Name = 'CHEMSUPPLYA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemSupplyA'
        DataType = dtBoolean
        DisplayName = 'CHEMSUPPLYA_SUPPLY_TIME_ONOFF'
        Name = 'CHEMSUPPLYA_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemSupplyA'
        DataType = dtDouble
        DisplayName = 'CHEMSUPPLYA_SUPPLY_TIMER'
        Name = 'CHEMSUPPLYA_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status ChemSupplyA'
        DataType = dtBoolean
        DisplayName = 'CHEMSUPPLYA_TIME_ONOFF'
        Name = 'CHEMSUPPLYA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemSupplyB'
        DisplayName = 'CHEMSUPPLYB_CURRENT_STEP'
        Name = 'CHEMSUPPLYB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemSupplyB'
        DataType = dtString
        DisplayName = 'CHEMSUPPLYB_CURRENT_STEP_NAME'
        Name = 'CHEMSUPPLYB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status ChemSupplyB'
        DataType = dtBoolean
        DisplayName = 'CHEMSUPPLYB_RUNNING'
        Name = 'CHEMSUPPLYB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemSupplyB'
        DataType = dtBoolean
        DisplayName = 'CHEMSUPPLYB_SUPPLY_TIME_ONOFF'
        Name = 'CHEMSUPPLYB_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status ChemSupplyB'
        DataType = dtDouble
        DisplayName = 'CHEMSUPPLYB_SUPPLY_TIMER'
        Name = 'CHEMSUPPLYB_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status ChemSupplyB'
        DataType = dtBoolean
        DisplayName = 'CHEMSUPPLYB_TIME_ONOFF'
        Name = 'CHEMSUPPLYB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DisplayName = 'CHEMSUPPLYTANKA_NO'
        Name = 'CHEMSUPPLYTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemSupplyA'
        DisplayName = 'CHEMSUPPLYTANKA_NO'
        Name = 'CHEMSUPPLYTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DisplayName = 'CHEMSUPPLYTANKB_NO'
        Name = 'CHEMSUPPLYTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status ChemSupplyB'
        DisplayName = 'CHEMSUPPLYTANKB_NO'
        Name = 'CHEMSUPPLYTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status System'
        DataType = dtDouble
        DisplayName = 'CYCLE_TIME_AVG'
        Name = 'CYCLE_TIME_AVG'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status System'
        DataType = dtDouble
        DisplayName = 'CYCLE_TIME_CURRENT'
        Name = 'CYCLE_TIME_CURRENT'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status System'
        DataType = dtDouble
        DisplayName = 'CYCLE_TIME_UPH'
        Name = 'CYCLE_TIME_UPH'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DisplayName = 'DIWCCSSSUPPLYA_CURRENT_STEP'
        Name = 'DIWCCSSSUPPLYA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DataType = dtString
        DisplayName = 'DIWCCSSSUPPLYA_CURRENT_STEP_NAME'
        Name = 'DIWCCSSSUPPLYA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'DIWCCSSSUPPLYA_RUNNING'
        Name = 'DIWCCSSSUPPLYA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'DIWCCSSSUPPLYA_SUPPLY_TIME_ONOFF'
        Name = 'DIWCCSSSUPPLYA_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DataType = dtDouble
        DisplayName = 'DIWCCSSSUPPLYA_SUPPLY_TIMER'
        Name = 'DIWCCSSSUPPLYA_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'DIWCCSSSUPPLYA_TIME_ONOFF'
        Name = 'DIWCCSSSUPPLYA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DisplayName = 'DIWCCSSSUPPLYB_CURRENT_STEP'
        Name = 'DIWCCSSSUPPLYB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DataType = dtString
        DisplayName = 'DIWCCSSSUPPLYB_CURRENT_STEP_NAME'
        Name = 'DIWCCSSSUPPLYB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'DIWCCSSSUPPLYB_RUNNING'
        Name = 'DIWCCSSSUPPLYB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'DIWCCSSSUPPLYB_SUPPLY_TIME_ONOFF'
        Name = 'DIWCCSSSUPPLYB_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DataType = dtDouble
        DisplayName = 'DIWCCSSSUPPLYB_SUPPLY_TIMER'
        Name = 'DIWCCSSSUPPLYB_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'DIWCCSSSUPPLYB_TIME_ONOFF'
        Name = 'DIWCCSSSUPPLYB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWCCSSSupplyA'
        DisplayName = 'DIWCCSSSUPPLYTANKA_NO'
        Name = 'DIWCCSSSUPPLYTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWCCSSSupplyB'
        DisplayName = 'DIWCCSSSUPPLYTANKB_NO'
        Name = 'DIWCCSSSUPPLYTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWSupplyA'
        DisplayName = 'DIWSUPPLYA_CURRENT_STEP'
        Name = 'DIWSUPPLYA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWSupplyA'
        DataType = dtString
        DisplayName = 'DIWSUPPLYA_CURRENT_STEP_NAME'
        Name = 'DIWSUPPLYA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DIWSupplyA'
        DataType = dtBoolean
        DisplayName = 'DIWSUPPLYA_RUNNING'
        Name = 'DIWSUPPLYA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWSupplyA'
        DataType = dtBoolean
        DisplayName = 'DIWSUPPLYA_TIME_ONOFF'
        Name = 'DIWSUPPLYA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWSupplyB'
        DisplayName = 'DIWSUPPLYB_CURRENT_STEP'
        Name = 'DIWSUPPLYB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWSupplyB'
        DataType = dtString
        DisplayName = 'DIWSUPPLYB_CURRENT_STEP_NAME'
        Name = 'DIWSUPPLYB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DIWSupplyB'
        DataType = dtBoolean
        DisplayName = 'DIWSUPPLYB_RUNNING'
        Name = 'DIWSUPPLYB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWSupplyB'
        DataType = dtBoolean
        DisplayName = 'DIWSUPPLYB_TIME_ONOFF'
        Name = 'DIWSUPPLYB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DIWSupplyA'
        DisplayName = 'DIWSUPPLYTANKA_NO'
        Name = 'DIWSUPPLYTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DIWSupplyB'
        DisplayName = 'DIWSUPPLYTANKB_NO'
        Name = 'DIWSUPPLYTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'DRAIN_TANK_N2_LINE_IN_VAL'
        Name = 'DRAIN_TANK_N2_LINE_IN_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DrainCir'
        DataType = dtBoolean
        DisplayName = 'DRAINCIR_CIR_RUN'
        Name = 'DRAINCIR_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainCir'
        DisplayName = 'DRAINCIR_CURRENT_STEP'
        Name = 'DRAINCIR_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainCir'
        DataType = dtString
        DisplayName = 'DRAINCIR_CURRENT_STEP_NAME'
        Name = 'DRAINCIR_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainCir'
        DataType = dtBoolean
        DisplayName = 'DRAINCIR_RUNNING'
        Name = 'DRAINCIR_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainCir'
        DisplayName = 'DRAINCIR_TANK_NO'
        Name = 'DRAINCIR_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainCir'
        DataType = dtBoolean
        DisplayName = 'DRAINCIR_TIME_ONOFF'
        Name = 'DRAINCIR_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtBoolean
        DisplayName = 'DRAINCIRPUMP_CS_TIME_ONOFF'
        Name = 'DRAINCIRPUMP_CS_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtDouble
        DisplayName = 'DRAINCIRPUMP_CS_TIMER'
        Name = 'DRAINCIRPUMP_CS_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DrainCirPump'
        DisplayName = 'DRAINCIRPUMP_CURRENT_STEP'
        Name = 'DRAINCIRPUMP_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtString
        DisplayName = 'DRAINCIRPUMP_CURRENT_STEP_NAME'
        Name = 'DRAINCIRPUMP_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtBoolean
        DisplayName = 'DRAINCIRPUMP_PUMP_TIME_ONOFF'
        Name = 'DRAINCIRPUMP_PUMP_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtDouble
        DisplayName = 'DRAINCIRPUMP_PUMP_TIMER'
        Name = 'DRAINCIRPUMP_PUMP_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtBoolean
        DisplayName = 'DRAINCIRPUMP_STATUS_PUMP_RUN'
        Name = 'DRAINCIRPUMP_STATUS_PUMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainCirPump'
        DataType = dtBoolean
        DisplayName = 'DRAINCIRPUMP_TIME_ONOFF'
        Name = 'DRAINCIRPUMP_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainDrain'
        DisplayName = 'DRAINDRAIN_CURRENT_STEP'
        Name = 'DRAINDRAIN_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainDrain'
        DataType = dtString
        DisplayName = 'DRAINDRAIN_CURRENT_STEP_NAME'
        Name = 'DRAINDRAIN_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainDrain'
        DataType = dtBoolean
        DisplayName = 'DRAINDRAIN_DRAIN_RUN'
        Name = 'DRAINDRAIN_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainDrain'
        DataType = dtBoolean
        DisplayName = 'DRAINDRAIN_RUNNING'
        Name = 'DRAINDRAIN_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainDrain'
        DisplayName = 'DRAINDRAIN_TANK_NO'
        Name = 'DRAINDRAIN_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainDrain'
        DataType = dtBoolean
        DisplayName = 'DRAINDRAIN_TIME_ONOFF'
        Name = 'DRAINDRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainLeak'
        DisplayName = 'DRAINLEAK_CURRENT_STEP'
        Name = 'DRAINLEAK_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainLeak'
        DataType = dtString
        DisplayName = 'DRAINLEAK_CURRENT_STEP_NAME'
        Name = 'DRAINLEAK_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainLeak'
        DataType = dtBoolean
        DisplayName = 'DRAINLEAK_DRAIN_RUN'
        Name = 'DRAINLEAK_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainLeak'
        DataType = dtBoolean
        DisplayName = 'DRAINLEAK_RUNNING'
        Name = 'DRAINLEAK_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainLeak'
        DisplayName = 'DRAINLEAK_TANK_NO'
        Name = 'DRAINLEAK_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainLeak'
        DataType = dtBoolean
        DisplayName = 'DRAINLEAK_TIME_ONOFF'
        Name = 'DRAINLEAK_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainOver'
        DisplayName = 'DRAINOVER_CURRENT_STEP'
        Name = 'DRAINOVER_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainOver'
        DataType = dtString
        DisplayName = 'DRAINOVER_CURRENT_STEP_NAME'
        Name = 'DRAINOVER_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainOver'
        DataType = dtBoolean
        DisplayName = 'DRAINOVER_OVER_RUN'
        Name = 'DRAINOVER_OVER_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainOver'
        DataType = dtBoolean
        DisplayName = 'DRAINOVER_RUNNING'
        Name = 'DRAINOVER_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainOver'
        DisplayName = 'DRAINOVER_TANK_NO'
        Name = 'DRAINOVER_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainOver'
        DataType = dtBoolean
        DisplayName = 'DRAINOVER_TIME_ONOFF'
        Name = 'DRAINOVER_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainPCWSupply'
        DisplayName = 'DRAINPCWSUPPLY_CURRENT_STEP'
        Name = 'DRAINPCWSUPPLY_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainPCWSupply'
        DataType = dtString
        DisplayName = 'DRAINPCWSUPPLY_CURRENT_STEP_NAME'
        Name = 'DRAINPCWSUPPLY_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainPCWSupply'
        DataType = dtBoolean
        DisplayName = 'DRAINPCWSUPPLY_RUN'
        Name = 'DRAINPCWSUPPLY_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainPCWSupply'
        DataType = dtBoolean
        DisplayName = 'DRAINPCWSUPPLY_RUNNING'
        Name = 'DRAINPCWSUPPLY_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainPCWSupply'
        DisplayName = 'DRAINPCWSUPPLY_TANK_NO'
        Name = 'DRAINPCWSUPPLY_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainPCWSupply'
        DataType = dtBoolean
        DisplayName = 'DRAINPCWSUPPLY_TIME_ONOFF'
        Name = 'DRAINPCWSUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankA'
        DisplayName = 'DRAINTANKA_CURRENT_STEP'
        Name = 'DRAINTANKA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainTankA'
        DataType = dtString
        DisplayName = 'DRAINTANKA_CURRENT_STEP_NAME'
        Name = 'DRAINTANKA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainTankA'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKA_DRAIN_RUN'
        Name = 'DRAINTANKA_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankA'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKA_DRAIN_TIME_ONOFF'
        Name = 'DRAINTANKA_DRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankA'
        DataType = dtDouble
        DisplayName = 'DRAINTANKA_DRAIN_TIMER'
        Name = 'DRAINTANKA_DRAIN_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DrainTankA'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKA_RUNNING'
        Name = 'DRAINTANKA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankA'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKA_TIME_ONOFF'
        Name = 'DRAINTANKA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankB'
        DisplayName = 'DRAINTANKB_CURRENT_STEP'
        Name = 'DRAINTANKB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainTankB'
        DataType = dtString
        DisplayName = 'DRAINTANKB_CURRENT_STEP_NAME'
        Name = 'DRAINTANKB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status DrainTankB'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKB_DRAIN_RUN'
        Name = 'DRAINTANKB_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankB'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKB_DRAIN_TIME_ONOFF'
        Name = 'DRAINTANKB_DRAIN_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankB'
        DataType = dtDouble
        DisplayName = 'DRAINTANKB_DRAIN_TIMER'
        Name = 'DRAINTANKB_DRAIN_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status DrainTankB'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKB_RUNNING'
        Name = 'DRAINTANKB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankB'
        DataType = dtBoolean
        DisplayName = 'DRAINTANKB_TIME_ONOFF'
        Name = 'DRAINTANKB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status DrainTankA'
        DisplayName = 'DRAINTANKTANKA_NO'
        Name = 'DRAINTANKTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status DrainTankB'
        DisplayName = 'DRAINTANKTANKB_NO'
        Name = 'DRAINTANKTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'DRUM_SUPPLY_LINE_PRESSURE_VAL'
        Name = 'DRUM_SUPPLY_LINE_PRESSURE_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '??????????'
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'FILTER_UNIT_FLUSHING_DIW_VAL'
        Name = 'FILTER_UNIT_FLUSHING_DIW_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '?????????????'
      end
      item
        Category = 'Status FilterLeak'
        DisplayName = 'FILTERLEAK_CURRENT_STEP'
        Name = 'FILTERLEAK_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status FilterLeak'
        DataType = dtString
        DisplayName = 'FILTERLEAK_CURRENT_STEP_NAME'
        Name = 'FILTERLEAK_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status FilterLeak'
        DataType = dtBoolean
        DisplayName = 'FILTERLEAK_DRAIN_RUN'
        Name = 'FILTERLEAK_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FilterLeak'
        DataType = dtBoolean
        DisplayName = 'FILTERLEAK_RUNNING'
        Name = 'FILTERLEAK_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FilterLeak'
        DisplayName = 'FILTERLEAK_TANK_NO'
        Name = 'FILTERLEAK_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status FilterLeak'
        DataType = dtBoolean
        DisplayName = 'FILTERLEAK_TIME_ONOFF'
        Name = 'FILTERLEAK_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FilterVent'
        DisplayName = 'FILTERVENT_CURRENT_STEP'
        Name = 'FILTERVENT_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status FilterVent'
        DataType = dtString
        DisplayName = 'FILTERVENT_CURRENT_STEP_NAME'
        Name = 'FILTERVENT_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status FilterVent'
        DataType = dtBoolean
        DisplayName = 'FILTERVENT_RUNNING'
        Name = 'FILTERVENT_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FilterVent'
        DataType = dtBoolean
        DisplayName = 'FILTERVENT_TIME_ONOFF'
        Name = 'FILTERVENT_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FilterVent'
        DataType = dtDouble
        DisplayName = 'FILTERVENT_TIMER'
        Name = 'FILTERVENT_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FilterVent'
        DataType = dtBoolean
        DisplayName = 'FILTERVENT_VENTON_TIME_ONOFF'
        Name = 'FILTERVENT_VENTON_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FilterVent'
        DataType = dtDouble
        DisplayName = 'FILTERVENT_VENTON_TIMER'
        Name = 'FILTERVENT_VENTON_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'FM_CONNECTED'
        Name = 'FM_CONNECTED'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKA_CHEM_ON'
        Name = 'FM_TANKA_CHEM_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtDouble
        DisplayName = 'FM_TANKA_CHEM_SETUP_VAL'
        Name = 'FM_TANKA_CHEM_SETUP_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FMControl'
        DataType = dtDouble
        DisplayName = 'FM_TANKA_CHEM2_SETUP_VAL'
        Name = 'FM_TANKA_CHEM2_SETUP_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKA_DIW_CCSS_ON'
        Name = 'FM_TANKA_DIW_CCSS_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKA_H2O2_CCSS_ON'
        Name = 'FM_TANKA_H2O2_CCSS_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKA_H2O2_ON'
        Name = 'FM_TANKA_H2O2_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKA_TMAH_CCSS_ON'
        Name = 'FM_TANKA_TMAH_CCSS_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKB_CHEM_ON'
        Name = 'FM_TANKB_CHEM_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtDouble
        DisplayName = 'FM_TANKB_CHEM_SETUP_VAL'
        Name = 'FM_TANKB_CHEM_SETUP_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FMControl'
        DataType = dtDouble
        DisplayName = 'FM_TANKB_CHEM2_SETUP_VAL'
        Name = 'FM_TANKB_CHEM2_SETUP_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKB_DIW_CCSS_ON'
        Name = 'FM_TANKB_DIW_CCSS_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKB_H2O2_CCSS_ON'
        Name = 'FM_TANKB_H2O2_CCSS_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKB_H2O2_ON'
        Name = 'FM_TANKB_H2O2_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FMControl'
        DataType = dtBoolean
        DisplayName = 'FM_TANKB_TMAH_CCSS_ON'
        Name = 'FM_TANKB_TMAH_CCSS_ON'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'H2O2_DRUM_UNIT_EXHAUST_VAL'
        Name = 'H2O2_DRUM_UNIT_EXHAUST_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '????????????'
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'H2O2_DRUM_UNIT_LINE_PRESSURE_VAL'
        Name = 'H2O2_DRUM_UNIT_LINE_PRESSURE_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '??????????'
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DisplayName = 'H2O2CCSSSUPPLYA_CURRENT_STEP'
        Name = 'H2O2CCSSSUPPLYA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DataType = dtString
        DisplayName = 'H2O2CCSSSUPPLYA_CURRENT_STEP_NAME'
        Name = 'H2O2CCSSSUPPLYA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'H2O2CCSSSUPPLYA_RUNNING'
        Name = 'H2O2CCSSSUPPLYA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'H2O2CCSSSUPPLYA_SUPPLY_TIME_ONOFF'
        Name = 'H2O2CCSSSUPPLYA_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DataType = dtDouble
        DisplayName = 'H2O2CCSSSUPPLYA_SUPPLY_TIMER'
        Name = 'H2O2CCSSSUPPLYA_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'H2O2CCSSSUPPLYA_TIME_ONOFF'
        Name = 'H2O2CCSSSUPPLYA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DisplayName = 'H2O2CCSSSUPPLYB_CURRENT_STEP'
        Name = 'H2O2CCSSSUPPLYB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DataType = dtString
        DisplayName = 'H2O2CCSSSUPPLYB_CURRENT_STEP_NAME'
        Name = 'H2O2CCSSSUPPLYB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'H2O2CCSSSUPPLYB_RUNNING'
        Name = 'H2O2CCSSSUPPLYB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'H2O2CCSSSUPPLYB_SUPPLY_TIME_ONOFF'
        Name = 'H2O2CCSSSUPPLYB_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DataType = dtDouble
        DisplayName = 'H2O2CCSSSUPPLYB_SUPPLY_TIMER'
        Name = 'H2O2CCSSSUPPLYB_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'H2O2CCSSSUPPLYB_TIME_ONOFF'
        Name = 'H2O2CCSSSUPPLYB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2CCSSSupplyA'
        DisplayName = 'H2O2CCSSSUPPLYTANKA_NO'
        Name = 'H2O2CCSSSUPPLYTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2CCSSSupplyB'
        DisplayName = 'H2O2CCSSSUPPLYTANKB_NO'
        Name = 'H2O2CCSSSUPPLYTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2DrumSel'
        DisplayName = 'H2O2DRUMSEL_CHANGE_DRUM_NO'
        Name = 'H2O2DRUMSEL_CHANGE_DRUM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2DrumSel'
        DataType = dtBoolean
        DisplayName = 'H2O2DRUMSEL_CHANGE_RUN'
        Name = 'H2O2DRUMSEL_CHANGE_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2DrumSel'
        DisplayName = 'H2O2DRUMSEL_CURRENT_STEP'
        Name = 'H2O2DRUMSEL_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2DrumSel'
        DataType = dtString
        DisplayName = 'H2O2DRUMSEL_CURRENT_STEP_NAME'
        Name = 'H2O2DRUMSEL_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status H2O2DrumSel'
        DataType = dtBoolean
        DisplayName = 'H2O2DRUMSEL_SEND_DATA_TO_HOST'
        Name = 'H2O2DRUMSEL_SEND_DATA_TO_HOST'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2DrumSel'
        DataType = dtBoolean
        DisplayName = 'H2O2DRUMSEL_SEND_DATA_TO_HOST_OK'
        Name = 'H2O2DRUMSEL_SEND_DATA_TO_HOST_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2DrumSel'
        DataType = dtBoolean
        DisplayName = 'H2O2DRUMSEL_STATUS_PUMP_RUN'
        Name = 'H2O2DRUMSEL_STATUS_PUMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2DrumSel'
        DataType = dtBoolean
        DisplayName = 'H2O2DRUMSEL_TIME_ONOFF'
        Name = 'H2O2DRUMSEL_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2Leak'
        DisplayName = 'H2O2LEAK_CURRENT_STEP'
        Name = 'H2O2LEAK_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2Leak'
        DataType = dtString
        DisplayName = 'H2O2LEAK_CURRENT_STEP_NAME'
        Name = 'H2O2LEAK_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status H2O2Leak'
        DataType = dtBoolean
        DisplayName = 'H2O2LEAK_DRAIN_RUN'
        Name = 'H2O2LEAK_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2Leak'
        DataType = dtBoolean
        DisplayName = 'H2O2LEAK_RUNNING'
        Name = 'H2O2LEAK_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2Leak'
        DisplayName = 'H2O2LEAK_TANK_NO'
        Name = 'H2O2LEAK_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2Leak'
        DataType = dtBoolean
        DisplayName = 'H2O2LEAK_TIME_ONOFF'
        Name = 'H2O2LEAK_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyA'
        DisplayName = 'H2O2SUPPLYA_CURRENT_STEP'
        Name = 'H2O2SUPPLYA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2SupplyA'
        DataType = dtString
        DisplayName = 'H2O2SUPPLYA_CURRENT_STEP_NAME'
        Name = 'H2O2SUPPLYA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status H2O2SupplyA'
        DataType = dtBoolean
        DisplayName = 'H2O2SUPPLYA_RUNNING'
        Name = 'H2O2SUPPLYA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyA'
        DataType = dtBoolean
        DisplayName = 'H2O2SUPPLYA_SUPPLY_TIME_ONOFF'
        Name = 'H2O2SUPPLYA_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyA'
        DataType = dtDouble
        DisplayName = 'H2O2SUPPLYA_SUPPLY_TIMER'
        Name = 'H2O2SUPPLYA_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status H2O2SupplyA'
        DataType = dtBoolean
        DisplayName = 'H2O2SUPPLYA_TIME_ONOFF'
        Name = 'H2O2SUPPLYA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyB'
        DisplayName = 'H2O2SUPPLYB_CURRENT_STEP'
        Name = 'H2O2SUPPLYB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2SupplyB'
        DataType = dtString
        DisplayName = 'H2O2SUPPLYB_CURRENT_STEP_NAME'
        Name = 'H2O2SUPPLYB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status H2O2SupplyB'
        DataType = dtBoolean
        DisplayName = 'H2O2SUPPLYB_RUNNING'
        Name = 'H2O2SUPPLYB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyB'
        DataType = dtBoolean
        DisplayName = 'H2O2SUPPLYB_SUPPLY_TIME_ONOFF'
        Name = 'H2O2SUPPLYB_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyB'
        DataType = dtDouble
        DisplayName = 'H2O2SUPPLYB_SUPPLY_TIMER'
        Name = 'H2O2SUPPLYB_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status H2O2SupplyB'
        DataType = dtBoolean
        DisplayName = 'H2O2SUPPLYB_TIME_ONOFF'
        Name = 'H2O2SUPPLYB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status H2O2SupplyA'
        DisplayName = 'H2O2SUPPLYTANKA_NO'
        Name = 'H2O2SUPPLYTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status H2O2SupplyB'
        DisplayName = 'H2O2SUPPLYTANKB_NO'
        Name = 'H2O2SUPPLYTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'INPUT_BARCODE'
        Name = 'INPUT_BARCODE'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'INPUT_BARCODE_CHEM'
        Name = 'INPUT_BARCODE_CHEM'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'INPUT_BARCODE_H2O2'
        Name = 'INPUT_BARCODE_H2O2'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'INPUT_BARCODE_MACHINE'
        Name = 'INPUT_BARCODE_MACHINE'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'INPUT_BARCODE_OK'
        Name = 'INPUT_BARCODE_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirA'
        DataType = dtBoolean
        DisplayName = 'LOCALCIRA_CIR_RUN'
        Name = 'LOCALCIRA_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirA'
        DisplayName = 'LOCALCIRA_CURRENT_STEP'
        Name = 'LOCALCIRA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status LocalCirA'
        DataType = dtString
        DisplayName = 'LOCALCIRA_CURRENT_STEP_NAME'
        Name = 'LOCALCIRA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status LocalCirA'
        DataType = dtBoolean
        DisplayName = 'LOCALCIRA_RUNNING'
        Name = 'LOCALCIRA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirA'
        DataType = dtBoolean
        DisplayName = 'LOCALCIRA_TIME_ONOFF'
        Name = 'LOCALCIRA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirB'
        DataType = dtBoolean
        DisplayName = 'LOCALCIRB_CIR_RUN'
        Name = 'LOCALCIRB_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirB'
        DisplayName = 'LOCALCIRB_CURRENT_STEP'
        Name = 'LOCALCIRB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status LocalCirB'
        DataType = dtString
        DisplayName = 'LOCALCIRB_CURRENT_STEP_NAME'
        Name = 'LOCALCIRB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status LocalCirB'
        DataType = dtBoolean
        DisplayName = 'LOCALCIRB_RUNNING'
        Name = 'LOCALCIRB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirB'
        DataType = dtBoolean
        DisplayName = 'LOCALCIRB_TIME_ONOFF'
        Name = 'LOCALCIRB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status LocalCirA'
        DisplayName = 'LOCALCIRTANKA_NO'
        Name = 'LOCALCIRTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status LocalCirB'
        DisplayName = 'LOCALCIRTANKB_NO'
        Name = 'LOCALCIRTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_DRUM_DRAIN_VAL'
        Name = 'MAIN_CDA_TO_DRUM_DRAIN_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_H2O2_DRUM_VAL'
        Name = 'MAIN_CDA_TO_H2O2_DRUM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_TANKA_VAL'
        Name = 'MAIN_CDA_TO_TANKA_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_CDA_TO_TANKB_VAL'
        Name = 'MAIN_CDA_TO_TANKB_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'MAIN_N2_VAL'
        Name = 'MAIN_N2_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status MainCirA'
        DataType = dtBoolean
        DisplayName = 'MAINCIRA_CIR_RUN'
        Name = 'MAINCIRA_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status MainCirA'
        DisplayName = 'MAINCIRA_CURRENT_STEP'
        Name = 'MAINCIRA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status MainCirA'
        DataType = dtString
        DisplayName = 'MAINCIRA_CURRENT_STEP_NAME'
        Name = 'MAINCIRA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status MainCirA'
        DataType = dtBoolean
        DisplayName = 'MAINCIRA_RUNNING'
        Name = 'MAINCIRA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status MainCirA'
        DataType = dtBoolean
        DisplayName = 'MAINCIRA_TIME_ONOFF'
        Name = 'MAINCIRA_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status MainCirB'
        DataType = dtBoolean
        DisplayName = 'MAINCIRB_CIR_RUN'
        Name = 'MAINCIRB_CIR_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status MainCirB'
        DisplayName = 'MAINCIRB_CURRENT_STEP'
        Name = 'MAINCIRB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status MainCirB'
        DataType = dtString
        DisplayName = 'MAINCIRB_CURRENT_STEP_NAME'
        Name = 'MAINCIRB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status MainCirB'
        DataType = dtBoolean
        DisplayName = 'MAINCIRB_RUNNING'
        Name = 'MAINCIRB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status MainCirB'
        DataType = dtBoolean
        DisplayName = 'MAINCIRB_TIME_ONOFF'
        Name = 'MAINCIRB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status MainCirA'
        DisplayName = 'MAINCIRTANKA_NO'
        Name = 'MAINCIRTANKA_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status MainCirB'
        DisplayName = 'MAINCIRTANKB_NO'
        Name = 'MAINCIRTANKB_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'PCW_LINE_IN_VAL'
        Name = 'PCW_LINE_IN_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'PCW_LINE_OUT_VAL'
        Name = 'PCW_LINE_OUT_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'POWER_ON_STATUS'
        Name = 'POWER_ON_STATUS'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'PURGE_N2_TO_FILTER_VAL'
        Name = 'PURGE_N2_TO_FILTER_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '??????????????'
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'RESET_POWER_PROCESS'
        Name = 'RESET_POWER_PROCESS'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'SAFETY_CONNECTED'
        Name = 'SAFETY_CONNECTED'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SEPARATOR_BOX_EXHAUST_VAL'
        Name = 'SEPARATOR_BOX_EXHAUST_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '????????'
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_13_FM_VAL'
        Name = 'SUPPLY_13_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_13_PS_VAL'
        Name = 'SUPPLY_13_PS_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '??????????'
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_24_FM_VAL'
        Name = 'SUPPLY_24_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_24_PS_VAL'
        Name = 'SUPPLY_24_PS_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '?????????'
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_57_FM_VAL'
        Name = 'SUPPLY_57_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_57_PS_VAL'
        Name = 'SUPPLY_57_PS_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '?????????'
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_68_FM_VAL'
        Name = 'SUPPLY_68_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'SUPPLY_68_PS_VAL'
        Name = 'SUPPLY_68_PS_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '???????'
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'SYS_STATUS_CAPTION'
        Name = 'SYS_STATUS_CAPTION'
        Tag = 0
        Value = 'IDLE'
      end
      item
        Category = 'Status System'
        DataType = dtString
        DisplayName = 'SYS_STATUS_CAPTION_LCD'
        Name = 'SYS_STATUS_CAPTION_LCD'
        Tag = 0
        Value = 'IDLE'
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_CHEM_DRUM_FM_VAL'
        Name = 'TANKA_CHEM_DRUM_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_DIW_CCSS_FM_VAL'
        Name = 'TANKA_DIW_CCSS_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_DIW_FM_VAL'
        Name = 'TANKA_DIW_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_EXHAUST_VAL'
        Name = 'TANKA_EXHAUST_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '?????????'
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_H2O2_CCSS_FM_VAL'
        Name = 'TANKA_H2O2_CCSS_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_H2O2_DRUM_FM_VAL'
        Name = 'TANKA_H2O2_DRUM_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_LASER_SENSOR_VAL'
        Name = 'TANKA_LASER_SENSOR_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'TANKA_N2_LINE_IN_VAL'
        Name = 'TANKA_N2_LINE_IN_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKA_TMAH_CCSS_FM_VAL'
        Name = 'TANKA_TMAH_CCSS_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtBoolean
        DisplayName = 'TANKACIRPUMP_CS_TIME_ONOFF'
        Name = 'TANKACIRPUMP_CS_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtDouble
        DisplayName = 'TANKACIRPUMP_CS_TIMER'
        Name = 'TANKACIRPUMP_CS_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TankACirPump'
        DisplayName = 'TANKACIRPUMP_CURRENT_STEP'
        Name = 'TANKACIRPUMP_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtString
        DisplayName = 'TANKACIRPUMP_CURRENT_STEP_NAME'
        Name = 'TANKACIRPUMP_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtBoolean
        DisplayName = 'TANKACIRPUMP_PUMP_TIME_ONOFF'
        Name = 'TANKACIRPUMP_PUMP_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtDouble
        DisplayName = 'TANKACIRPUMP_PUMP_TIMER'
        Name = 'TANKACIRPUMP_PUMP_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtBoolean
        DisplayName = 'TANKACIRPUMP_STATUS_PUMP_RUN'
        Name = 'TANKACIRPUMP_STATUS_PUMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankACirPump'
        DataType = dtBoolean
        DisplayName = 'TANKACIRPUMP_TIME_ONOFF'
        Name = 'TANKACIRPUMP_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankALeak'
        DisplayName = 'TANKALEAK_CURRENT_STEP'
        Name = 'TANKALEAK_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankALeak'
        DataType = dtString
        DisplayName = 'TANKALEAK_CURRENT_STEP_NAME'
        Name = 'TANKALEAK_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TankALeak'
        DataType = dtBoolean
        DisplayName = 'TANKALEAK_DRAIN_RUN'
        Name = 'TANKALEAK_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankALeak'
        DataType = dtBoolean
        DisplayName = 'TANKALEAK_RUNNING'
        Name = 'TANKALEAK_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankALeak'
        DisplayName = 'TANKALEAK_TANK_NO'
        Name = 'TANKALEAK_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankALeak'
        DataType = dtBoolean
        DisplayName = 'TANKALEAK_TIME_ONOFF'
        Name = 'TANKALEAK_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankAOver'
        DisplayName = 'TANKAOVER_CURRENT_STEP'
        Name = 'TANKAOVER_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankAOver'
        DataType = dtString
        DisplayName = 'TANKAOVER_CURRENT_STEP_NAME'
        Name = 'TANKAOVER_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TankAOver'
        DataType = dtBoolean
        DisplayName = 'TANKAOVER_OVER_RUN'
        Name = 'TANKAOVER_OVER_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankAOver'
        DataType = dtBoolean
        DisplayName = 'TANKAOVER_RUNNING'
        Name = 'TANKAOVER_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankAOver'
        DisplayName = 'TANKAOVER_TANK_NO'
        Name = 'TANKAOVER_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankAOver'
        DataType = dtBoolean
        DisplayName = 'TANKAOVER_TIME_ONOFF'
        Name = 'TANKAOVER_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_CHEM_DRUM_FM_VAL'
        Name = 'TANKB_CHEM_DRUM_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_DIW_CCSS_FM_VAL'
        Name = 'TANKB_DIW_CCSS_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_DIW_FM_VAL'
        Name = 'TANKB_DIW_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_EXHAUST_VAL'
        Name = 'TANKB_EXHAUST_VAL'
        Tag = 0
        Value = 0.000000000000000000
        ZDescription = '???????????'
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_H2O2_CCSS_FM_VAL'
        Name = 'TANKB_H2O2_CCSS_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_H2O2_DRUM_FM_VAL'
        Name = 'TANKB_H2O2_DRUM_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_LASER_SENSOR_VAL'
        Name = 'TANKB_LASER_SENSOR_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Analog'
        DataType = dtDouble
        DisplayName = 'TANKB_N2_LINE_IN_VAL'
        Name = 'TANKB_N2_LINE_IN_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status FlowMeter'
        DataType = dtDouble
        DisplayName = 'TANKB_TMAH_CCSS_FM_VAL'
        Name = 'TANKB_TMAH_CCSS_FM_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtBoolean
        DisplayName = 'TANKBCIRPUMP_CS_TIME_ONOFF'
        Name = 'TANKBCIRPUMP_CS_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtDouble
        DisplayName = 'TANKBCIRPUMP_CS_TIMER'
        Name = 'TANKBCIRPUMP_CS_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TankBCirPump'
        DisplayName = 'TANKBCIRPUMP_CURRENT_STEP'
        Name = 'TANKBCIRPUMP_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtString
        DisplayName = 'TANKBCIRPUMP_CURRENT_STEP_NAME'
        Name = 'TANKBCIRPUMP_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtBoolean
        DisplayName = 'TANKBCIRPUMP_PUMP_TIME_ONOFF'
        Name = 'TANKBCIRPUMP_PUMP_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtDouble
        DisplayName = 'TANKBCIRPUMP_PUMP_TIMER'
        Name = 'TANKBCIRPUMP_PUMP_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtBoolean
        DisplayName = 'TANKBCIRPUMP_STATUS_PUMP_RUN'
        Name = 'TANKBCIRPUMP_STATUS_PUMP_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBCirPump'
        DataType = dtBoolean
        DisplayName = 'TANKBCIRPUMP_TIME_ONOFF'
        Name = 'TANKBCIRPUMP_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBLeak'
        DisplayName = 'TANKBLEAK_CURRENT_STEP'
        Name = 'TANKBLEAK_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankBLeak'
        DataType = dtString
        DisplayName = 'TANKBLEAK_CURRENT_STEP_NAME'
        Name = 'TANKBLEAK_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TankBLeak'
        DataType = dtBoolean
        DisplayName = 'TANKBLEAK_DRAIN_RUN'
        Name = 'TANKBLEAK_DRAIN_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBLeak'
        DataType = dtBoolean
        DisplayName = 'TANKBLEAK_RUNNING'
        Name = 'TANKBLEAK_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBLeak'
        DisplayName = 'TANKBLEAK_TANK_NO'
        Name = 'TANKBLEAK_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankBLeak'
        DataType = dtBoolean
        DisplayName = 'TANKBLEAK_TIME_ONOFF'
        Name = 'TANKBLEAK_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBOver'
        DisplayName = 'TANKBOVER_CURRENT_STEP'
        Name = 'TANKBOVER_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankBOver'
        DataType = dtString
        DisplayName = 'TANKBOVER_CURRENT_STEP_NAME'
        Name = 'TANKBOVER_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TankBOver'
        DataType = dtBoolean
        DisplayName = 'TANKBOVER_OVER_RUN'
        Name = 'TANKBOVER_OVER_RUN'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBOver'
        DataType = dtBoolean
        DisplayName = 'TANKBOVER_RUNNING'
        Name = 'TANKBOVER_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TankBOver'
        DisplayName = 'TANKBOVER_TANK_NO'
        Name = 'TANKBOVER_TANK_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TankBOver'
        DataType = dtBoolean
        DisplayName = 'TANKBOVER_TIME_ONOFF'
        Name = 'TANKBOVER_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_DRAIN1_VAL'
        Name = 'TC_DRAIN1_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_DRAIN2_VAL'
        Name = 'TC_DRAIN2_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_CONTROL_VAL'
        Name = 'TC_TANKA_1_CONTROL_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_INTERLOCK1_VAL'
        Name = 'TC_TANKA_1_INTERLOCK1_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_INTERLOCK2_VAL'
        Name = 'TC_TANKA_1_INTERLOCK2_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_1_TANK_VAL'
        Name = 'TC_TANKA_1_TANK_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_CONTROL_VAL'
        Name = 'TC_TANKA_2_CONTROL_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_INTERLOCK1_VAL'
        Name = 'TC_TANKA_2_INTERLOCK1_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_INTERLOCK2_VAL'
        Name = 'TC_TANKA_2_INTERLOCK2_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKA_2_TANK_VAL'
        Name = 'TC_TANKA_2_TANK_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_CONTROL_VAL'
        Name = 'TC_TANKB_1_CONTROL_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_INTERLOCK1_VAL'
        Name = 'TC_TANKB_1_INTERLOCK1_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_INTERLOCK2_VAL'
        Name = 'TC_TANKB_1_INTERLOCK2_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_1_TANK_VAL'
        Name = 'TC_TANKB_1_TANK_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_CONTROL_VAL'
        Name = 'TC_TANKB_2_CONTROL_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_INTERLOCK1_VAL'
        Name = 'TC_TANKB_2_INTERLOCK1_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_INTERLOCK2_VAL'
        Name = 'TC_TANKB_2_INTERLOCK2_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status Temp'
        DataType = dtDouble
        DisplayName = 'TC_TANKB_2_TANK_VAL'
        Name = 'TC_TANKB_2_TANK_VAL'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'TEMP_CONNECTED'
        Name = 'TEMP_CONNECTED'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DisplayName = 'TMAHCCSSSUPPLYA_CURRENT_STEP'
        Name = 'TMAHCCSSSUPPLYA_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DataType = dtString
        DisplayName = 'TMAHCCSSSUPPLYA_CURRENT_STEP_NAME'
        Name = 'TMAHCCSSSUPPLYA_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'TMAHCCSSSUPPLYA_RUNNING'
        Name = 'TMAHCCSSSUPPLYA_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'TMAHCCSSSUPPLYA_SUPPLY_TIME_ONOFF'
        Name = 'TMAHCCSSSUPPLYA_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DataType = dtDouble
        DisplayName = 'TMAHCCSSSUPPLYA_SUPPLY_TIMER'
        Name = 'TMAHCCSSSUPPLYA_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TMAHCCSSSupplyA'
        DataType = dtBoolean
        DisplayName = 'TMAHCCSSSUPPLYa_TIME_ONOFF'
        Name = 'TMAHCCSSSUPPLYa_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DisplayName = 'TMAHCCSSSUPPLYB_CURRENT_STEP'
        Name = 'TMAHCCSSSUPPLYB_CURRENT_STEP'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DataType = dtString
        DisplayName = 'TMAHCCSSSUPPLYB_CURRENT_STEP_NAME'
        Name = 'TMAHCCSSSUPPLYB_CURRENT_STEP_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'TMAHCCSSSUPPLYB_RUNNING'
        Name = 'TMAHCCSSSUPPLYB_RUNNING'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'TMAHCCSSSUPPLYB_SUPPLY_TIME_ONOFF'
        Name = 'TMAHCCSSSUPPLYB_SUPPLY_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DataType = dtDouble
        DisplayName = 'TMAHCCSSSUPPLYB_SUPPLY_TIMER'
        Name = 'TMAHCCSSSUPPLYB_SUPPLY_TIMER'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Status TMAHCCSSSupplyB'
        DataType = dtBoolean
        DisplayName = 'TMAHCCSSSUPPLYB_TIME_ONOFF'
        Name = 'TMAHCCSSSUPPLYB_TIME_ONOFF'
        Tag = 0
        Value = False
      end
      item
        Category = 'Status System'
        DataType = dtBoolean
        DisplayName = 'WMX_CONNECTED'
        Name = 'WMX_CONNECTED'
        Tag = 0
        Value = False
      end>
    ChannelPrefix = 'S_'
    SimulateItems = <>
    OnChannelChanged = IOServerChannelChanged
    Left = 56
    Top = 24
  end
  object ChannelChecker: TfoChannelChecker
    Resolution = 50
    OnCompletionError = ChannelCheckerCompletionError
    Left = 56
    Top = 180
  end
  object JobServer: TfoDataServer
    OnError = DataServerError
    Channels = <
      item
        Category = 'DEVICE'
        DisplayName = 'DEVICE_CAM_DIFF_COUNT'
        Name = 'DEVICE_CAM_DIFF_COUNT'
        Tag = 0
        Value = 6
      end
      item
        Category = 'DEVICE'
        DisplayName = 'DEVICE_COUNT_X'
        Name = 'DEVICE_COUNT_X'
        Tag = 0
        Value = 10
      end
      item
        Category = 'DEVICE'
        DisplayName = 'DEVICE_COUNT_Y'
        Name = 'DEVICE_COUNT_Y'
        Tag = 0
        Value = 1
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'DEVICE_MARK_POS'
        Name = 'DEVICE_MARK_POS'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'DEVICE_PITCH_X'
        Name = 'DEVICE_PITCH_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'DEVICE_PITCH_Y'
        Name = 'DEVICE_PITCH_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'DEVICE_REF_POS'
        Name = 'DEVICE_REF_POS'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'LIGHT'
        DisplayName = 'LIGHT1_VAL1'
        Name = 'LIGHT1_VAL1'
        Tag = 0
        Value = 100
      end
      item
        Category = 'LIGHT'
        DisplayName = 'LIGHT1_VAL2'
        Name = 'LIGHT1_VAL2'
        Tag = 0
        Value = 100
      end
      item
        Category = 'LIGHT'
        DisplayName = 'LIGHT1_VAL3'
        Name = 'LIGHT1_VAL3'
        Tag = 0
        Value = 100
      end
      item
        Category = 'LIGHT'
        DisplayName = 'LIGHT1_VAL4'
        Name = 'LIGHT1_VAL4'
        Tag = 0
        Value = 100
      end
      item
        Category = 'Laser'
        DataType = dtString
        DisplayName = 'MAP_FILE_NAME'
        Name = 'MAP_FILE_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Laser'
        DataType = dtString
        DisplayName = 'PEN_FILE_NAME'
        Name = 'PEN_FILE_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'SPEC'
        DisplayName = 'SPEC_DEVICE_AVG_MAX'
        Name = 'SPEC_DEVICE_AVG_MAX'
        Tag = 0
        Value = 255
      end
      item
        Category = 'SPEC'
        DisplayName = 'SPEC_DEVICE_AVG_MIN'
        Name = 'SPEC_DEVICE_AVG_MIN'
        Tag = 0
        Value = 0
      end
      item
        Category = 'SPEC'
        DataType = dtDouble
        DisplayName = 'SPEC_GAP'
        Name = 'SPEC_GAP'
        Tag = 0
        Value = 0.180000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'TRIGGER_END_POS'
        Name = 'TRIGGER_END_POS'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'TRIGGER_GRAB_OFFSET'
        Name = 'TRIGGER_GRAB_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'TRIGGER_SCAN_OFFSET'
        Name = 'TRIGGER_SCAN_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'TRIGGER_SCAN_SPEED'
        Name = 'TRIGGER_SCAN_SPEED'
        Tag = 0
        Value = 10.000000000000000000
      end
      item
        Category = 'DEVICE'
        DataType = dtDouble
        DisplayName = 'TRIGGER_START_POS'
        Name = 'TRIGGER_START_POS'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision'
        DisplayName = 'V1_INSP_COUNT'
        Name = 'V1_INSP_COUNT'
        Tag = 0
        Value = 1
      end
      item
        Category = 'LIGHT'
        DisplayName = 'V1_LIGHT'
        Name = 'V1_LIGHT'
        Tag = 0
        Value = 500
      end
      item
        Category = 'Vision1_01'
        DisplayName = 'V1I01_ALGORITHM_NO'
        Name = 'V1I01_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_01'
        DisplayName = 'V1I01_BIN_NO'
        Name = 'V1I01_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_CORR'
        Name = 'V1I01_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DisplayName = 'V1I01_INSP_NO'
        Name = 'V1I01_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_01'
        DataType = dtString
        DisplayName = 'V1I01_MODELS'
        Name = 'V1I01_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_01'
        DataType = dtString
        DisplayName = 'V1I01_NAME'
        Name = 'V1I01_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_OFFSET'
        Name = 'V1I01_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DataType = dtString
        DisplayName = 'V1I01_REF_ITEMS'
        Name = 'V1I01_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_SPEC_MAX'
        Name = 'V1I01_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_SPEC_MIN'
        Name = 'V1I01_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_TARGET_T'
        Name = 'V1I01_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_TARGET_X'
        Name = 'V1I01_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DataType = dtDouble
        DisplayName = 'V1I01_TARGET_Y'
        Name = 'V1I01_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_01'
        DataType = dtBoolean
        DisplayName = 'V1I01_USE'
        Name = 'V1I01_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_02'
        DisplayName = 'V1I02_ALGORITHM_NO'
        Name = 'V1I02_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_02'
        DisplayName = 'V1I02_BIN_NO'
        Name = 'V1I02_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_CORR'
        Name = 'V1I02_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DisplayName = 'V1I02_INSP_NO'
        Name = 'V1I02_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_02'
        DataType = dtString
        DisplayName = 'V1I02_MODELS'
        Name = 'V1I02_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_02'
        DataType = dtString
        DisplayName = 'V1I02_NAME'
        Name = 'V1I02_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_OFFSET'
        Name = 'V1I02_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DataType = dtString
        DisplayName = 'V1I02_REF_ITEMS'
        Name = 'V1I02_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_SPEC_MAX'
        Name = 'V1I02_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_SPEC_MIN'
        Name = 'V1I02_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_TARGET_T'
        Name = 'V1I02_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_TARGET_X'
        Name = 'V1I02_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DataType = dtDouble
        DisplayName = 'V1I02_TARGET_Y'
        Name = 'V1I02_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_02'
        DataType = dtBoolean
        DisplayName = 'V1I02_USE'
        Name = 'V1I02_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_03'
        DisplayName = 'V1I03_ALGORITHM_NO'
        Name = 'V1I03_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_03'
        DisplayName = 'V1I03_BIN_NO'
        Name = 'V1I03_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_CORR'
        Name = 'V1I03_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DisplayName = 'V1I03_INSP_NO'
        Name = 'V1I03_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_03'
        DataType = dtString
        DisplayName = 'V1I03_MODELS'
        Name = 'V1I03_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_03'
        DataType = dtString
        DisplayName = 'V1I03_NAME'
        Name = 'V1I03_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_OFFSET'
        Name = 'V1I03_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DataType = dtString
        DisplayName = 'V1I03_REF_ITEMS'
        Name = 'V1I03_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_SPEC_MAX'
        Name = 'V1I03_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_SPEC_MIN'
        Name = 'V1I03_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_TARGET_T'
        Name = 'V1I03_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_TARGET_X'
        Name = 'V1I03_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DataType = dtDouble
        DisplayName = 'V1I03_TARGET_Y'
        Name = 'V1I03_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_03'
        DataType = dtBoolean
        DisplayName = 'V1I03_USE'
        Name = 'V1I03_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_04'
        DisplayName = 'V1I04_ALGORITHM_NO'
        Name = 'V1I04_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_04'
        DisplayName = 'V1I04_BIN_NO'
        Name = 'V1I04_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_CORR'
        Name = 'V1I04_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DisplayName = 'V1I04_INSP_NO'
        Name = 'V1I04_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_04'
        DataType = dtString
        DisplayName = 'V1I04_MODELS'
        Name = 'V1I04_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_04'
        DataType = dtString
        DisplayName = 'V1I04_NAME'
        Name = 'V1I04_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_OFFSET'
        Name = 'V1I04_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DataType = dtString
        DisplayName = 'V1I04_REF_ITEMS'
        Name = 'V1I04_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_SPEC_MAX'
        Name = 'V1I04_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_SPEC_MIN'
        Name = 'V1I04_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_TARGET_T'
        Name = 'V1I04_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_TARGET_X'
        Name = 'V1I04_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DataType = dtDouble
        DisplayName = 'V1I04_TARGET_Y'
        Name = 'V1I04_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_04'
        DataType = dtBoolean
        DisplayName = 'V1I04_USE'
        Name = 'V1I04_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_05'
        DisplayName = 'V1I05_ALGORITHM_NO'
        Name = 'V1I05_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_05'
        DisplayName = 'V1I05_BIN_NO'
        Name = 'V1I05_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_CORR'
        Name = 'V1I05_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DisplayName = 'V1I05_INSP_NO'
        Name = 'V1I05_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_05'
        DataType = dtString
        DisplayName = 'V1I05_MODELS'
        Name = 'V1I05_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_05'
        DataType = dtString
        DisplayName = 'V1I05_NAME'
        Name = 'V1I05_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_OFFSET'
        Name = 'V1I05_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DataType = dtString
        DisplayName = 'V1I05_REF_ITEMS'
        Name = 'V1I05_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_SPEC_MAX'
        Name = 'V1I05_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_SPEC_MIN'
        Name = 'V1I05_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_TARGET_T'
        Name = 'V1I05_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_TARGET_X'
        Name = 'V1I05_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DataType = dtDouble
        DisplayName = 'V1I05_TARGET_Y'
        Name = 'V1I05_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_05'
        DataType = dtBoolean
        DisplayName = 'V1I05_USE'
        Name = 'V1I05_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_06'
        DisplayName = 'V1I06_ALGORITHM_NO'
        Name = 'V1I06_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_06'
        DisplayName = 'V1I06_BIN_NO'
        Name = 'V1I06_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_CORR'
        Name = 'V1I06_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DisplayName = 'V1I06_INSP_NO'
        Name = 'V1I06_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_06'
        DataType = dtString
        DisplayName = 'V1I06_MODELS'
        Name = 'V1I06_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_06'
        DataType = dtString
        DisplayName = 'V1I06_NAME'
        Name = 'V1I06_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_OFFSET'
        Name = 'V1I06_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DataType = dtString
        DisplayName = 'V1I06_REF_ITEMS'
        Name = 'V1I06_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_SPEC_MAX'
        Name = 'V1I06_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_SPEC_MIN'
        Name = 'V1I06_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_TARGET_T'
        Name = 'V1I06_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_TARGET_X'
        Name = 'V1I06_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DataType = dtDouble
        DisplayName = 'V1I06_TARGET_Y'
        Name = 'V1I06_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_06'
        DataType = dtBoolean
        DisplayName = 'V1I06_USE'
        Name = 'V1I06_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_07'
        DisplayName = 'V1I07_ALGORITHM_NO'
        Name = 'V1I07_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_07'
        DisplayName = 'V1I07_BIN_NO'
        Name = 'V1I07_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_CORR'
        Name = 'V1I07_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DisplayName = 'V1I07_INSP_NO'
        Name = 'V1I07_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_07'
        DataType = dtString
        DisplayName = 'V1I07_MODELS'
        Name = 'V1I07_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_07'
        DataType = dtString
        DisplayName = 'V1I07_NAME'
        Name = 'V1I07_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_OFFSET'
        Name = 'V1I07_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DataType = dtString
        DisplayName = 'V1I07_REF_ITEMS'
        Name = 'V1I07_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_SPEC_MAX'
        Name = 'V1I07_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_SPEC_MIN'
        Name = 'V1I07_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_TARGET_T'
        Name = 'V1I07_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_TARGET_X'
        Name = 'V1I07_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DataType = dtDouble
        DisplayName = 'V1I07_TARGET_Y'
        Name = 'V1I07_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_07'
        DataType = dtBoolean
        DisplayName = 'V1I07_USE'
        Name = 'V1I07_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_08'
        DisplayName = 'V1I08_ALGORITHM_NO'
        Name = 'V1I08_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_08'
        DisplayName = 'V1I08_BIN_NO'
        Name = 'V1I08_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_CORR'
        Name = 'V1I08_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DisplayName = 'V1I08_INSP_NO'
        Name = 'V1I08_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_08'
        DataType = dtString
        DisplayName = 'V1I08_MODELS'
        Name = 'V1I08_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_08'
        DataType = dtString
        DisplayName = 'V1I08_NAME'
        Name = 'V1I08_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_OFFSET'
        Name = 'V1I08_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DataType = dtString
        DisplayName = 'V1I08_REF_ITEMS'
        Name = 'V1I08_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_SPEC_MAX'
        Name = 'V1I08_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_SPEC_MIN'
        Name = 'V1I08_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_TARGET_T'
        Name = 'V1I08_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_TARGET_X'
        Name = 'V1I08_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DataType = dtDouble
        DisplayName = 'V1I08_TARGET_Y'
        Name = 'V1I08_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_08'
        DataType = dtBoolean
        DisplayName = 'V1I08_USE'
        Name = 'V1I08_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision1_09'
        DisplayName = 'V1I09_ALGORITHM_NO'
        Name = 'V1I09_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_09'
        DisplayName = 'V1I09_BIN_NO'
        Name = 'V1I09_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_CORR'
        Name = 'V1I09_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DisplayName = 'V1I09_INSP_NO'
        Name = 'V1I09_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision1_09'
        DataType = dtString
        DisplayName = 'V1I09_MODELS'
        Name = 'V1I09_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_09'
        DataType = dtString
        DisplayName = 'V1I09_NAME'
        Name = 'V1I09_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_OFFSET'
        Name = 'V1I09_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DataType = dtString
        DisplayName = 'V1I09_REF_ITEMS'
        Name = 'V1I09_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_SPEC_MAX'
        Name = 'V1I09_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_SPEC_MIN'
        Name = 'V1I09_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_TARGET_T'
        Name = 'V1I09_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_TARGET_X'
        Name = 'V1I09_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DataType = dtDouble
        DisplayName = 'V1I09_TARGET_Y'
        Name = 'V1I09_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision1_09'
        DataType = dtBoolean
        DisplayName = 'V1I09_USE'
        Name = 'V1I09_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision'
        DisplayName = 'V2_INSP_COUNT'
        Name = 'V2_INSP_COUNT'
        Tag = 0
        Value = 0
      end
      item
        Category = 'LIGHT'
        DisplayName = 'V2_LIGHT'
        Name = 'V2_LIGHT'
        Tag = 0
        Value = 500
      end
      item
        Category = 'Vision2_01'
        DisplayName = 'V2I01_ALGORITHM_NO'
        Name = 'V2I01_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_01'
        DisplayName = 'V2I01_BIN_NO'
        Name = 'V2I01_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_CORR'
        Name = 'V2I01_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DisplayName = 'V2I01_INSP_NO'
        Name = 'V2I01_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_01'
        DataType = dtString
        DisplayName = 'V2I01_MODELS'
        Name = 'V2I01_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_01'
        DataType = dtString
        DisplayName = 'V2I01_NAME'
        Name = 'V2I01_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_OFFSET'
        Name = 'V2I01_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DataType = dtString
        DisplayName = 'V2I01_REF_ITEMS'
        Name = 'V2I01_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_SPEC_MAX'
        Name = 'V2I01_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_SPEC_MIN'
        Name = 'V2I01_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_TARGET_T'
        Name = 'V2I01_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_TARGET_X'
        Name = 'V2I01_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DataType = dtDouble
        DisplayName = 'V2I01_TARGET_Y'
        Name = 'V2I01_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_01'
        DataType = dtBoolean
        DisplayName = 'V2I01_USE'
        Name = 'V2I01_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_02'
        DisplayName = 'V2I02_ALGORITHM_NO'
        Name = 'V2I02_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_02'
        DisplayName = 'V2I02_BIN_NO'
        Name = 'V2I02_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_CORR'
        Name = 'V2I02_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DisplayName = 'V2I02_INSP_NO'
        Name = 'V2I02_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_02'
        DataType = dtString
        DisplayName = 'V2I02_MODELS'
        Name = 'V2I02_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_02'
        DataType = dtString
        DisplayName = 'V2I02_NAME'
        Name = 'V2I02_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_OFFSET'
        Name = 'V2I02_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DataType = dtString
        DisplayName = 'V2I02_REF_ITEMS'
        Name = 'V2I02_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_SPEC_MAX'
        Name = 'V2I02_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_SPEC_MIN'
        Name = 'V2I02_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_TARGET_T'
        Name = 'V2I02_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_TARGET_X'
        Name = 'V2I02_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DataType = dtDouble
        DisplayName = 'V2I02_TARGET_Y'
        Name = 'V2I02_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_02'
        DataType = dtBoolean
        DisplayName = 'V2I02_USE'
        Name = 'V2I02_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_03'
        DisplayName = 'V2I03_ALGORITHM_NO'
        Name = 'V2I03_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_03'
        DisplayName = 'V2I03_BIN_NO'
        Name = 'V2I03_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_CORR'
        Name = 'V2I03_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DisplayName = 'V2I03_INSP_NO'
        Name = 'V2I03_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_03'
        DataType = dtString
        DisplayName = 'V2I03_MODELS'
        Name = 'V2I03_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_03'
        DataType = dtString
        DisplayName = 'V2I03_NAME'
        Name = 'V2I03_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_OFFSET'
        Name = 'V2I03_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DataType = dtString
        DisplayName = 'V2I03_REF_ITEMS'
        Name = 'V2I03_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_SPEC_MAX'
        Name = 'V2I03_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_SPEC_MIN'
        Name = 'V2I03_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_TARGET_T'
        Name = 'V2I03_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_TARGET_X'
        Name = 'V2I03_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DataType = dtDouble
        DisplayName = 'V2I03_TARGET_Y'
        Name = 'V2I03_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_03'
        DataType = dtBoolean
        DisplayName = 'V2I03_USE'
        Name = 'V2I03_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_04'
        DisplayName = 'V2I04_ALGORITHM_NO'
        Name = 'V2I04_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_04'
        DisplayName = 'V2I04_BIN_NO'
        Name = 'V2I04_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_CORR'
        Name = 'V2I04_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DisplayName = 'V2I04_INSP_NO'
        Name = 'V2I04_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_04'
        DataType = dtString
        DisplayName = 'V2I04_MODELS'
        Name = 'V2I04_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_04'
        DataType = dtString
        DisplayName = 'V2I04_NAME'
        Name = 'V2I04_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_OFFSET'
        Name = 'V2I04_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DataType = dtString
        DisplayName = 'V2I04_REF_ITEMS'
        Name = 'V2I04_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_SPEC_MAX'
        Name = 'V2I04_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_SPEC_MIN'
        Name = 'V2I04_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_TARGET_T'
        Name = 'V2I04_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_TARGET_X'
        Name = 'V2I04_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DataType = dtDouble
        DisplayName = 'V2I04_TARGET_Y'
        Name = 'V2I04_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_04'
        DataType = dtBoolean
        DisplayName = 'V2I04_USE'
        Name = 'V2I04_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_05'
        DisplayName = 'V2I05_ALGORITHM_NO'
        Name = 'V2I05_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_05'
        DisplayName = 'V2I05_BIN_NO'
        Name = 'V2I05_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_CORR'
        Name = 'V2I05_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DisplayName = 'V2I05_INSP_NO'
        Name = 'V2I05_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_05'
        DataType = dtString
        DisplayName = 'V2I05_MODELS'
        Name = 'V2I05_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_05'
        DataType = dtString
        DisplayName = 'V2I05_NAME'
        Name = 'V2I05_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_OFFSET'
        Name = 'V2I05_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DataType = dtString
        DisplayName = 'V2I05_REF_ITEMS'
        Name = 'V2I05_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_SPEC_MAX'
        Name = 'V2I05_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_SPEC_MIN'
        Name = 'V2I05_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_TARGET_T'
        Name = 'V2I05_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_TARGET_X'
        Name = 'V2I05_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DataType = dtDouble
        DisplayName = 'V2I05_TARGET_Y'
        Name = 'V2I05_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_05'
        DataType = dtBoolean
        DisplayName = 'V2I05_USE'
        Name = 'V2I05_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_06'
        DisplayName = 'V2I06_ALGORITHM_NO'
        Name = 'V2I06_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_06'
        DisplayName = 'V2I06_BIN_NO'
        Name = 'V2I06_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_CORR'
        Name = 'V2I06_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DisplayName = 'V2I06_INSP_NO'
        Name = 'V2I06_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_06'
        DataType = dtString
        DisplayName = 'V2I06_MODELS'
        Name = 'V2I06_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_06'
        DataType = dtString
        DisplayName = 'V2I06_NAME'
        Name = 'V2I06_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_OFFSET'
        Name = 'V2I06_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DataType = dtString
        DisplayName = 'V2I06_REF_ITEMS'
        Name = 'V2I06_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_SPEC_MAX'
        Name = 'V2I06_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_SPEC_MIN'
        Name = 'V2I06_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_TARGET_T'
        Name = 'V2I06_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_TARGET_X'
        Name = 'V2I06_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DataType = dtDouble
        DisplayName = 'V2I06_TARGET_Y'
        Name = 'V2I06_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_06'
        DataType = dtBoolean
        DisplayName = 'V2I06_USE'
        Name = 'V2I06_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_07'
        DisplayName = 'V2I07_ALGORITHM_NO'
        Name = 'V2I07_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_07'
        DisplayName = 'V2I07_BIN_NO'
        Name = 'V2I07_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_CORR'
        Name = 'V2I07_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DisplayName = 'V2I07_INSP_NO'
        Name = 'V2I07_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_07'
        DataType = dtString
        DisplayName = 'V2I07_MODELS'
        Name = 'V2I07_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_07'
        DataType = dtString
        DisplayName = 'V2I07_NAME'
        Name = 'V2I07_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_OFFSET'
        Name = 'V2I07_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DataType = dtString
        DisplayName = 'V2I07_REF_ITEMS'
        Name = 'V2I07_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_SPEC_MAX'
        Name = 'V2I07_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_SPEC_MIN'
        Name = 'V2I07_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_TARGET_T'
        Name = 'V2I07_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_TARGET_X'
        Name = 'V2I07_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DataType = dtDouble
        DisplayName = 'V2I07_TARGET_Y'
        Name = 'V2I07_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_07'
        DataType = dtBoolean
        DisplayName = 'V2I07_USE'
        Name = 'V2I07_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_08'
        DisplayName = 'V2I08_ALGORITHM_NO'
        Name = 'V2I08_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_08'
        DisplayName = 'V2I08_BIN_NO'
        Name = 'V2I08_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_CORR'
        Name = 'V2I08_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DisplayName = 'V2I08_INSP_NO'
        Name = 'V2I08_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_08'
        DataType = dtString
        DisplayName = 'V2I08_MODELS'
        Name = 'V2I08_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_08'
        DataType = dtString
        DisplayName = 'V2I08_NAME'
        Name = 'V2I08_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_OFFSET'
        Name = 'V2I08_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DataType = dtString
        DisplayName = 'V2I08_REF_ITEMS'
        Name = 'V2I08_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_SPEC_MAX'
        Name = 'V2I08_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_SPEC_MIN'
        Name = 'V2I08_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_TARGET_T'
        Name = 'V2I08_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_TARGET_X'
        Name = 'V2I08_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DataType = dtDouble
        DisplayName = 'V2I08_TARGET_Y'
        Name = 'V2I08_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_08'
        DataType = dtBoolean
        DisplayName = 'V2I08_USE'
        Name = 'V2I08_USE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Vision2_09'
        DisplayName = 'V2I09_ALGORITHM_NO'
        Name = 'V2I09_ALGORITHM_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_09'
        DisplayName = 'V2I09_BIN_NO'
        Name = 'V2I09_BIN_NO'
        Tag = 0
        Value = 2
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_CORR'
        Name = 'V2I09_CORR'
        Tag = 0
        Value = 1.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DisplayName = 'V2I09_INSP_NO'
        Name = 'V2I09_INSP_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Vision2_09'
        DataType = dtString
        DisplayName = 'V2I09_MODELS'
        Name = 'V2I09_MODELS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_09'
        DataType = dtString
        DisplayName = 'V2I09_NAME'
        Name = 'V2I09_NAME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_OFFSET'
        Name = 'V2I09_OFFSET'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DataType = dtString
        DisplayName = 'V2I09_REF_ITEMS'
        Name = 'V2I09_REF_ITEMS'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_SPEC_MAX'
        Name = 'V2I09_SPEC_MAX'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_SPEC_MIN'
        Name = 'V2I09_SPEC_MIN'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_TARGET_T'
        Name = 'V2I09_TARGET_T'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_TARGET_X'
        Name = 'V2I09_TARGET_X'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DataType = dtDouble
        DisplayName = 'V2I09_TARGET_Y'
        Name = 'V2I09_TARGET_Y'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Vision2_09'
        DataType = dtBoolean
        DisplayName = 'V2I09_USE'
        Name = 'V2I09_USE'
        Tag = 0
        Value = False
      end>
    ChannelPrefix = 'J_'
    SimulateItems = <>
    OnChannelChanged = JobServerChannelChanged
    Left = 56
    Top = 132
  end
  object RecipeServer: TfoDataServer
    OnError = DataServerError
    Channels = <
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_CHEM_DRUM_A_HAVE'
        Name = 'STS_CHEM_DRUM_A_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_CHEM_DRUM_B_HAVE'
        Name = 'STS_CHEM_DRUM_B_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_CHEM_DRUM_USE_NO'
        Name = 'STS_CHEM_DRUM_USE_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_DRAIN_STATUS_NO'
        Name = 'STS_DRAIN_STATUS_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_H2O2_DRUM_A_HAVE'
        Name = 'STS_H2O2_DRUM_A_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_H2O2_DRUM_B_HAVE'
        Name = 'STS_H2O2_DRUM_B_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_H2O2_DRUM_USE_NO'
        Name = 'STS_H2O2_DRUM_USE_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtDouble
        DisplayName = 'STS_LAST_UPDATED_AT'
        Name = 'STS_LAST_UPDATED_AT'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_CHEM_SUPPLY_OK'
        Name = 'STS_TANKA_CHEM_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_DIW_SUPPLY_OK'
        Name = 'STS_TANKA_DIW_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_H2O2_SUPPLY_OK'
        Name = 'STS_TANKA_H2O2_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKA_KIND_NO'
        Name = 'STS_TANKA_KIND_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKA_STATUS_NO'
        Name = 'STS_TANKA_STATUS_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_CHEM_SUPPLY_OK'
        Name = 'STS_TANKB_CHEM_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_DIW_SUPPLY_OK'
        Name = 'STS_TANKB_DIW_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_H2O2_SUPPLY_OK'
        Name = 'STS_TANKB_H2O2_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKB_KIND_NO'
        Name = 'STS_TANKB_KIND_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKB_STATUS_NO'
        Name = 'STS_TANKB_STATUS_NO'
        Tag = 0
        Value = 0
      end>
    ChannelPrefix = 'R_'
    SimulateItems = <>
    Left = 56
    Top = 236
  end
  object StsServer: TfoDataServer
    OnError = DataServerError
    Channels = <
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_CHEM_DRUM_A_HAVE'
        Name = 'STS_CHEM_DRUM_A_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_CHEM_DRUM_B_HAVE'
        Name = 'STS_CHEM_DRUM_B_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_CHEM_DRUM_USE_NO'
        Name = 'STS_CHEM_DRUM_USE_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_DRAIN_STATUS_NO'
        Name = 'STS_DRAIN_STATUS_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_H2O2_DRUM_A_HAVE'
        Name = 'STS_H2O2_DRUM_A_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_H2O2_DRUM_B_HAVE'
        Name = 'STS_H2O2_DRUM_B_HAVE'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_H2O2_DRUM_USE_NO'
        Name = 'STS_H2O2_DRUM_USE_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtDouble
        DisplayName = 'STS_LAST_UPDATED_AT'
        Name = 'STS_LAST_UPDATED_AT'
        Tag = 0
        Value = 0.000000000000000000
      end
      item
        Category = 'Statistics'
        DataType = dtString
        DisplayName = 'STS_TANKA_CHEM_SUPPLY_DATETIME'
        Name = 'STS_TANKA_CHEM_SUPPLY_DATETIME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_CHEM_SUPPLY_OK'
        Name = 'STS_TANKA_CHEM_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_DIW_SUPPLY_OK'
        Name = 'STS_TANKA_DIW_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_H2O2_SUPPLY_OK'
        Name = 'STS_TANKA_H2O2_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKA_KIND_NO'
        Name = 'STS_TANKA_KIND_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKA_STATUS_NO'
        Name = 'STS_TANKA_STATUS_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKA_TMAH_SUPPLY_OK'
        Name = 'STS_TANKA_TMAH_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtString
        DisplayName = 'STS_TANKB_CHEM_SUPPLY_DATETIME'
        Name = 'STS_TANKB_CHEM_SUPPLY_DATETIME'
        Tag = 0
        Value = ''
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_CHEM_SUPPLY_OK'
        Name = 'STS_TANKB_CHEM_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_DIW_SUPPLY_OK'
        Name = 'STS_TANKB_DIW_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_H2O2_SUPPLY_OK'
        Name = 'STS_TANKB_H2O2_SUPPLY_OK'
        Tag = 0
        Value = False
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKB_KIND_NO'
        Name = 'STS_TANKB_KIND_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DisplayName = 'STS_TANKB_STATUS_NO'
        Name = 'STS_TANKB_STATUS_NO'
        Tag = 0
        Value = 0
      end
      item
        Category = 'Statistics'
        DataType = dtBoolean
        DisplayName = 'STS_TANKB_TMAH_SUPPLY_OK'
        Name = 'STS_TANKB_TMAH_SUPPLY_OK'
        Tag = 0
        Value = False
      end>
    ChannelPrefix = 'S_'
    SimulateItems = <>
    Left = 56
    Top = 292
  end
  object elAlarmLog: TelLog
    Active = False
    Delimiter = #9
    LogBy = lbDate
    Options = [loAppendDate, loAppendLineBreak, loAppendTime]
    Left = 113
    Top = 30
  end
end
