% Constants
R = 287;                 % J/kg.K
GAMMA = 1.4;             
MU = 1.83e-5;            % Pa-s
T01 = 293;               % K
P_REF = 101325;          % Pa (Standard Atmosphere)
L_P = 0.2;               % m (Prototype length)
TARGET_M = 0.5;          
TARGET_RE = 3.0e6;       
P_MIN_ALLOWED = 200000;  % 200 kPa

% Isentropic factors for Ma = 0.5
ISENTROPIC_T_FACTOR = 1 + (GAMMA - 1) / 2 * TARGET_M^2;  % 1.05
ISENTROPIC_P_FACTOR = ISENTROPIC_T_FACTOR^(GAMMA / (GAMMA - 1)); % ~1.186

data = readmatrix('C:\Users\hp\Downloads\Compressor_operation_map.xlsx');
map_mdot_ref = data(:, 1);  % mdot_ref(kg/s)
map_T0_ratio = data(:, 2);  % T0 ratio (T02/T01)
map_P0_ratio = data(:, 3);  % P0 ratio (p02/p01)

results = struct('s', {}, 'p01', {}, 'p4', {}, 'mdot_ref', {}, 'p0_ratio', {});
valid_count = 0;

for i = 1:length(map_mdot_ref)
    mdot_ref = map_mdot_ref(i);
    t0_ratio = map_T0_ratio(i);
    p0_ratio = map_P0_ratio(i);
    
    % (T04 = T02)
    T04 = t0_ratio * T01; 
    T4 = T04 / ISENTROPIC_T_FACTOR;
    C4 = TARGET_M * sqrt(GAMMA * R * T4);

    % Derivation: s^2 = [mdot_ref * p01_const_part] / [mdot_const_part]
    % Re*mu*pi*l_p*s = mdot_ref * (p01/p_ref)
    
    % p01 in terms of 1/s: p01 = (Re*mu*R*T4 * P_FACTOR) / (C4*l_p*s * 0.985 * p0_ratio)
    p01_numerator = TARGET_RE * MU * R * T4 * ISENTROPIC_P_FACTOR;
    p01_denominator_no_s = C4 * L_P * 0.985 * p0_ratio;
    
    % Re*mu*pi*l_p * s = (mdot_ref / p_ref) * (p01_numerator / (p01_denominator_no_s * s))
    
    s_squared = (mdot_ref * p01_numerator) / (P_REF * p01_denominator_no_s * TARGET_RE * MU * pi * L_P);
    s = sqrt(s_squared);

    l_model = s * L_P;
    p4 = (TARGET_RE * MU * R * T4) / (C4 * l_model);
    
    p04 = p4 * ISENTROPIC_P_FACTOR;
    p02 = p04 / 0.985;
    p01 = p02 / p0_ratio;
    p05 = 0.95 * p04;
    
    if s <= 1.0 && p4 >= P_MIN_ALLOWED && p05 >= p01
        valid_count = valid_count + 1;
        results(valid_count).s = s;
        results(valid_count).p01 = p01;
        results(valid_count).p4 = p4;
        results(valid_count).mdot_ref = mdot_ref;
        results(valid_count).p0_ratio = p0_ratio;
    end
end

if ~isempty(results)
    df_res = struct2table(results);
    
    [~, max_idx] = max(df_res.s);
    best = df_res(max_idx, :);
    
    fprintf('PLOT\n');
    fprintf('Maximum Geometric Scale (s): %.6f\n', best.s);
    fprintf('Inlet Stagnation Pressure (p01): %.2f Pa\n', best.p01);
    fprintf('Min Static Pressure (p4): %.2f Pa\n', best.p4);
    fprintf('Operating Point: mdot_ref=%.4f, p0_ratio=%.4f\n', best.mdot_ref, best.p0_ratio);

    figure('Name', 'Compressor Map', 'Position', [100, 100, 800, 500]);
    hold on;
    

    plot(map_mdot_ref, map_P0_ratio, 'o', 'Color', [0.8 0.8 0.8], 'MarkerFaceColor', [0.8 0.8 0.8], 'DisplayName', 'Compressor Map Points');
    
  
    plot(best.mdot_ref, best.p0_ratio, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Optimal Point (Max s)');
    

    xlabel('Reference Mass Flow Rate ($\dot{m}_{ref}$) [kg/s]', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('Stagnation Pressure Ratio ($p_{02}/p_{01}$)', 'Interpreter', 'latex', 'FontSize', 12);
    title('Compressor Operating Map \& Selected Test Point', 'Interpreter', 'latex', 'FontSize', 14);
    
    legend('Location', 'best', 'Interpreter', 'latex');
    grid on;
    hold off;
else
    disp('No valid compressor points found meeting all constraints.');
end