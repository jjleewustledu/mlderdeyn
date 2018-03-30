classdef Np755 
	%% NP755  

	%  $Revision$
 	%  was created 19-Jan-2016 15:20:46
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		
    end
    
    methods (Static)
        function fqdns = sessionsForTestingPLaif
            dts = mlsystem.DirTools( ...
                fullfile(getenv('NP755'), 'mm*'), ...
                fullfile(getenv('NP797'), 'wu*'));
            fqdns = {};
            for d = 1:length(dts)
                if (mlderdeyn.Np755.hasHoDcv(dts.fqdns{d}))
                    fqdns = [fqdns dts.fqdns{d}];
                end
            end
        end
        function tf = hasHoDcv(dn)
            dt = mlsystem.DirTool(fullfile(dn, 'ECAT_EXACT', 'pet', '*ho*.dcv'));
            if (~isempty(dt.fns))
                tf = true;
                return
            end
            tf = false;
        end
    end

	methods 
		  
 		function this = Np755(varargin)
 			%% NP755
 			%  Usage:  this = Np755()

 			
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

