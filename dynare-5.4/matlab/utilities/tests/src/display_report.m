function display_report(r)

% Display detailed report on screen.
%
% INPUTS
% - r       [cell]   Output of run_all_unitary_tests routine.
%
% OUTPUTS
% none

% Copyright (C) 2018 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <https://www.gnu.org/licenses/>.

% Number of unit tests.
n = size(r, 1);

% Preallocated a cell array for test results (PASS/FAILED)
R = cell(n, 1);

for i=1:n
    if r{i,3}
        R{i} = 'PASS';
    else
        R{i} = 'FAILED';
    end
end

Results = [char(r(:,1)), repmat(' Unit test number ', n, 1), num2str(cell2mat(r(:,2))), repmat('  ', n, 1), char(R) repmat('  [ ', n,1), num2str(cell2mat(r(:,5))), repmat(' ]', n,1)];

Results