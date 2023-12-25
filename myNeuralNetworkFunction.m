function [Y,Xf,Af] = myNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 14-Dec-2023 16:32:40.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx3 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx3 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1_xoffset = [1;0;0];
x1_step1_gain = [2;0.0188270733314506;4.65116279069767];
x1_step1_ymin = -1;

% Layer 1
b1 = [7.2473140056086276;6.468860487714247;0.9864067230278436;-0.058825729695918962;0.99561318810869914;-0.61576453546687593;-3.8880948132667092;0.13936288635608468;-7.9760167571943157;-4.931820793461716];
IW1_1 = [-3.9734919809110143 5.3696466931511422 -3.8159927279180228;-0.43625170837391236 -4.0000052138890219 4.3219999213205806;-0.76696769397328246 -1.7198349585176615 -0.27096193544522607;-0.57722682980970252 0.42292253111570616 -0.85722515701212021;0.24332217248261556 -0.13061075991236853 2.70394832152749;2.6723228108544115 -2.183192859862221 3.8455586851424668;-5.6443664209660716 -4.836597777657401 5.7376954344505355;-2.101543379712151 0.92522907360096396 0.54435415687602773;-2.011130235509285 -2.1062424086172946 -7.6287061813123245;-1.1345468061757602 -1.5888062040054654 -4.524603240197199];

% Layer 2
b2 = [-0.49357390200541529;-1.1181458758845386;-0.47675378350699005];
LW2_1 = [-0.26982294680411889 0.69201854324885925 0.026873079683085287 2.3180636547909272 0.42703785204996703 0.66063215283601251 0.2668634181122978 -0.64039957817893856 -0.54805726177068148 -0.039698094712331627;-0.021808387157387026 1.060429609020402 -0.64925713274510599 -2.5693960187987877 -2.33430561347391 -0.58755883368835438 0.36193567499876572 0.60712472636316017 0.80360376766755337 -1.7262043202591872;0.95300723009835941 0.47067455553805276 -0.10439813661155325 4.5911329492573731 1.1819786584802818 1.7726462532713547 0.9988787910125343 -1.7503212761078282 2.3443693222607171 -2.5010609098966419];

% Output 1
y1_step1_ymin = -1;
y1_step1_gain = [0.625;0.421052631578947;0.294117647058824];
y1_step1_xoffset = [18.2;9.45;7.9];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX, X = {X}; end;

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},1); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    X{1,ts} = X{1,ts}';
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1_gain,y1_step1_xoffset,y1_step1_ymin);
    Y{1,ts} = Y{1,ts}';
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
y = bsxfun(@minus,x,settings_xoffset);
y = bsxfun(@times,y,settings_gain);
y = bsxfun(@plus,y,settings_ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings_gain,settings_xoffset,settings_ymin)
x = bsxfun(@minus,y,settings_ymin);
x = bsxfun(@rdivide,x,settings_gain);
x = bsxfun(@plus,x,settings_xoffset);
end