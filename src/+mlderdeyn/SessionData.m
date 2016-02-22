classdef SessionData < mlpipeline.SessionData
	%% SESSIONDATA  

	%  $Revision$
 	%  was created 15-Feb-2016 02:06:13
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    methods
        function f = T1_fqfn(this)
            f = this.fullfile(this.mriPath, 'T1.mgz');
        end
        function f = aparcA2009sAseg_fqfn(this)
            f = this.fullfile(this.mriPath, 'aparc.a2009s+aseg.mgz');
        end
        function f = ep2d_fqfn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            
            f = this.fullfile(this.fslPath, ['ep2d_default' ip.Results.suff '.nii.gz']);
        end	
        function f = ho_fqfn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            
            fp = sprintf('%sho%i', this.pnumber, this.snumber);
            f  = this.fullfile(fullfile(this.petPath, [fp '_frames']), [fp ip.Results.suff '.nii.gz']);
        end
        function f = mpr_fqfn(this)
            f = this.fullfile(this.fslPath, 't1_default.nii.gz');
        end
        function f = oc_fqfn(this)            
            fp = sprintf('%soc%i', this.pnumber, this.snumber);
            f  = this.fullfile(fullfile(this.petPath, [fp '_frames']), [fp '_03.nii.gz']);
        end
        function f = oo_fqfn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
              
            fp = sprintf('%soo%i', this.pnumber, this.snumber);
            f  = this.fullfile(fullfile(this.petPath, [fp '_frames']), [fp ip.Results.suff '.nii.gz']);
        end
        function f = orig_fqfn(this)
            f = this.fullfile(this.mriPath, 'orig.mgz');
        end
        function f = pet_fqfns(this)
            f = { this.oc_fqfn this.oo_fqfn this.ho_fqfn this.tr_fqfn };
        end
        function f = tof_fqfn(this)
            f = this.fullfile(this.petPath, 'tof_default.nii.gz');
        end
        function f = tr_fqfn(this)
            fp = sprintf('%str%i', this.pnumber, this.snumber);
            f  = this.fullfile(fullfile(this.petPath, [fp '_frames']), [fp '_01.nii.gz']);
        end
        function f = wmparc_fqfn(this)
            f = this.fullfile(this.mriPath, 'wmparc.mgz');
        end	
        
        
        
        
        function g = aparcA2009sAseg(this)
            g = mlmr.MRImagingContext(this.aparcA2009sAseg_fqfn);
        end
        function g = ep2d(this)
            g = mlmr.MRImagingContext(this.ep2d_fqfn);
        end
        function g = ho(this)
            import mlpet.*;
            if (lexist(this.ho_fqfn('_mcf')))
                g = PETImagingContext(this.ho_fqfn('_mcf'));
                return
            end
            g = PETImagingContext(this.ho_fqfn);
        end
        function g = mpr(this)
            g = mlmr.MRImagingContext(this.mpr_fqfn);
        end
        function g = oc(this) 
            g = mlpet.PETImagingContext(this.oc_fqfn);
        end
        function g = oo(this)
            import mlpet.*;
            if (lexist(this.oo_fqfn('_mcf')))
                g = PETImagingContext(this.oo_fqfn('_mcf'));
                return
            end
            g = PETImagingContext(this.oo_fqfn);
        end
        function g = orig(this)
            g = mlmr.MRImagingContext(this.orig_fqfn);
        end
        function g = petAtlas(this)
            g = mlpet.PETImagingContext(this.pet_fqfns);
            g = g.atlas;
        end      
        function p = petPointSpread(~)
            p = mlpet.PETRegistry.instance.petPointSpread;
        end
        function g = tof(this)
            g = mlmr.MRImagingContext(this.tof_fqfn);
        end
        function g = tr(this)
            g = mlpet.PETImagingContext(this.tr_fqfn);
        end
        function g = T1(this)
            g = mlmr.MRImagingContext(this.T1_fqfn);
        end
        function g = wmparc(this)
            g = mlmr.MRImagingContext(this.wmparc_fqfn);
        end
        
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  Usage:  this = SessionData()

 			this = this@mlpipeline.SessionData(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

