# checking that the heat-energy postprocessor correctly calculates the energy
# 1phase, constant porosity
[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 3
  xmin = 0
  xmax = 1
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [./temp]
  [../]
  [./pp]
  [../]
[]

[ICs]
  [./tinit]
    type = FunctionIC
    function = '100*x'
    variable = temp
  [../]
  [./pinit]
    type = FunctionIC
    function = 'x'
    variable = pp
  [../]
[]

[Kernels]
  [./dummyt]
    type = TimeDerivative
    variable = temp
  [../]
  [./dummyp]
    type = TimeDerivative
    variable = pp
  [../]
[]

[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'temp pp'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
  [./pc]
    type = PorousFlowCapillaryPressureVG
    m = 0.5
    alpha = 1
  [../]
[]

[Modules]
  [./FluidProperties]
    [./simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 1
      density0 = 1
      viscosity = 0.001
      thermal_expansion = 0
      cv = 1.3
    [../]
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
    at_nodes = true
    temperature = temp
  [../]
  [./porosity]
    type = PorousFlowPorosity
    at_nodes = true
    porosity_zero = 0.1
  [../]
  [./rock_heat]
    type = PorousFlowMatrixInternalEnergy
    at_nodes = true
    specific_heat_capacity = 2.2
    density = 0.5
  [../]
  [./ppss]
    type = PorousFlow1PhaseP
    at_nodes = true
    porepressure = pp
    capillary_pressure = pc
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    at_nodes = true
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
  [../]
  [./internal_energy_fluids]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_internal_energy_nodal
  [../]
[]

[Postprocessors]
  [./total_heat]
    type = PorousFlowHeatEnergy
    phase = 0
  [../]
  [./rock_heat]
    type = PorousFlowHeatEnergy
  [../]
  [./fluid_heat]
    type = PorousFlowHeatEnergy
    include_porous_skeleton = false
    phase = 0
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1 1 10000'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  dt = 1
  end_time = 1
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = heat02
  csv = true
[]
