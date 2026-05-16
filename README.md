# Compressor Test Model Scaling Using Dynamic Similarity

## Overview
This project analyzes the scaling of a compressor test model for a closed-loop experimental facility while maintaining dynamic similarity with a given prototype. The study focuses on satisfying Mach number and Reynolds number similarity constraints along with operational pressure limitations.

The analysis was carried out using MATLAB and compressor map data to identify the optimal operating point that maximizes the geometric scale factor of the model.

---

## Objectives
- Maintain Reynolds number similarity
- Maintain Mach number similarity
- Satisfy minimum static pressure constraints
- Ensure feasible compressor operating conditions
- Determine the maximum achievable geometric scaling factor

---

## Methodology
The project uses:
- Thermodynamic relations
- Isentropic flow relations
- Compressor operating map analysis
- MATLAB-based numerical computation

The compressor operating point is selected by evaluating valid operating conditions from the compressor map and maximizing the geometric scale factor.

---

## Key Features
- Compressor map visualization
- Operating point optimization
- Dynamic similarity verification
- Pressure and flow constraint validation
- MATLAB-based computational workflow

---

## Files Included
- `ME302.m` → MATLAB script for calculations and plotting
- `Compressor_operation_map.xlsx` → Compressor map dataset
- `compressor_map.png` → Generated compressor operating map
- `ME302_Project.pdf` → Detailed project report

---

## Results
The analysis identified an optimal operating point at the high-flow, low-pressure-ratio region of the compressor map, enabling the largest feasible model scale while satisfying all operational constraints.

Key verified conditions:
- Mach number matching
- Reynolds number matching
- Minimum pressure requirement
- Closed-loop pressure feasibility

---

## Tools & Technologies
- MATLAB
- Thermodynamic and turbomachinery analysis
- Compressor map data processing

---

## Authors
- Yash Bhardwaj
- C Dhawan
- Shashank Katiyar

---

## Academic Context
Developed as part of the **ME302: Energy System II / Turbomachines** course project.
