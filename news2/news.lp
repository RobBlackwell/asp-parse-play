% Toy example ASP program that implements National Early Warning Score
% (NEWS) 2
%
% NEWS a standardized scoring system used across hospitals and
% community settings in the UK to quickly assess the severity of a
% patient’s illness and detect early signs of deterioration, especially
% with conditions like sepsis, pneumonia, or COVID-19.
%
% See https://www.rcp.ac.uk/improving-care/resources/national-early-warning-score-news-2/
%
% SAFETY: Prototype for research/training only — NOT for clinical use.



% ========= INPUT FACTS (put in a separate file, e.g., case.lp) =========
% resp_rate(<breaths_per_min>).
% spo2(<percent_saturation>).         % Scale 1 only
% oxygen(air).                        % OR: oxygen(supplemental)
% sbp(<systolic_mmHg>).
% pulse(<beats_per_min>).
% temp_c(<celsius>).
% consciousness(alert|voice|pain|unresponsive|confusion).

% ----- Validity constraints: require exactly one input for each -----
:- not 1 { resp_rate(_) } 1.
:- not 1 { spo2(_) } 1.
:- not 1 { oxygen(_) } 1.
:- not 1 { sbp(_) } 1.
:- not 1 { pulse(_) } 1.
:- not 1 { temp_c(_) } 1.
:- not 1 { consciousness(_) } 1.
% ----- Respiration rate (per min) -----
score(respiration,3) :- resp_rate(R), R <= 8.
score(respiration,1) :- resp_rate(R), R >= 9,  R <= 11.
score(respiration,0) :- resp_rate(R), R >= 12, R <= 20.
score(respiration,2) :- resp_rate(R), R >= 21, R <= 24.
score(respiration,3) :- resp_rate(R), R >= 25.

% ----- SpO2 (Scale 1) -----
score(spo2,3) :- spo2(S), S <= 91.
score(spo2,2) :- spo2(S), S >= 92, S <= 93.
score(spo2,1) :- spo2(S), S >= 94, S <= 95.
score(spo2,0) :- spo2(S), S >= 96.

% ----- Oxygen therapy -----
score(oxygen,2) :- oxygen(supplemental).
score(oxygen,0) :- oxygen(air).

% ----- Systolic blood pressure (mmHg) -----
score(sbp,3) :- sbp(B), B <= 90.
score(sbp,2) :- sbp(B), B >= 91,  B <= 100.
score(sbp,1) :- sbp(B), B >= 101, B <= 110.
score(sbp,0) :- sbp(B), B >= 111, B <= 219.
score(sbp,3) :- sbp(B), B >= 220.

% ----- Pulse (beats/min) -----
score(pulse,3) :- pulse(P), P <= 40.
score(pulse,1) :- pulse(P), P >= 41,  P <= 50.
score(pulse,0) :- pulse(P), P >= 51,  P <= 90.
score(pulse,1) :- pulse(P), P >= 91,  P <= 110.
score(pulse,2) :- pulse(P), P >= 111, P <= 130.
score(pulse,3) :- pulse(P), P >= 131.

% ----- Temperature (°C, integers only) -----
%   3 points ≤35
%   1 point  36
%   0 points 37–38
%   1 point  39
%   2 points ≥40
score(temp,3) :- temp_c(T), T <= 35.
score(temp,1) :- temp_c(T), T = 36.
score(temp,0) :- temp_c(T), T >= 37, T <= 38.
score(temp,1) :- temp_c(T), T = 39.
score(temp,2) :- temp_c(T), T >= 40.

% ----- Consciousness / new confusion (ACVPU) -----
score(consciousness,0) :- consciousness(alert).
score(consciousness,3) :- consciousness(confusion).
score(consciousness,3) :- consciousness(voice).
score(consciousness,3) :- consciousness(pain).
score(consciousness,3) :- consciousness(unresponsive).

% ----- Totals, bands, and “single 3” trigger -----
totalscore(S) :- S = #sum { P,Param : score(Param,P) }.
single_red :- score(Param,3), Param != oxygen.

band(low)    :- totalscore(S), S >= 0, S <= 4.
band(medium) :- totalscore(S), S >= 5, S <= 6.
band(high)   :- totalscore(S), S >= 7.

trigger(single_red_3) :- single_red.

#show score/2.
#show totalscore/1.
#show band/1.
#show trigger/1.
