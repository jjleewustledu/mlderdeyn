classdef SessionData < mlpipeline.SessionData
	%% SESSIONDATA  

	%  $Revision$
 	%  was created 15-Feb-2016 02:06:13
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    properties 
        filetypeExt = '.nii.gz'
    end
    
    properties (Dependent)
        petBlur
    end
    
    methods %% GET
        function g = get.petBlur(~)
            g = mlpet.PETRegistry.instance.petPointSpread;
            g = mean(g);
        end
    end
    
    methods
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %         'nac'         is logical
            %         'rnumber'     is numeric
            %         'sessionPath' is a path to the session data
            %         'studyData'   is a mlpipeline.StudyDataSingleton
            %         'snumber'     is numeric
            %         'tracer'      is char
            %         'vnumber'     is numeric
            %         'tag'         is appended to the fileprefix

 			this = this@mlpipeline.SessionData(varargin{:});
            this.nac_ = false;
        end
        
        %% IMRData
               
        function obj = ep2d(this, varargin)
            obj = this.mrObject('ep2d_default_mcf', varargin{:});
        end
        function obj = mpr(this, varargin)
            obj = this.mrObject('t1_default', varargin{:});
        end
        function obj = tof(this, varargin)
            obj = this.mrObject('tof_default', varargin{:});
        end
                
        %% IPETData
        
        function loc = cossLocation(this, typ)
            loc = this.studyData_.locationType(typ, ...
                fullfile(this.vLocation('path'), 'ECAT_EXACT', 'coss', ''));
        end
        function loc = hdrinfoLocation(this, typ)
            loc = this.studyData_.locationType(typ, ...
                fullfile(this.vLocation('path'), 'ECAT_EXACT', 'hdr_backup', ''));
        end
        function loc = petLocation(this, typ)
            loc = this.studyData_.locationType(typ, ...
                fullfile(this.vLocation('path'), 'ECAT_EXACT', 'pet', ''));
        end
        function obj = petObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = this.studyData_.imagingType(ip.Results.typ, ...
                fullfile(this.petLocation('path'), ...
                         sprintf('%s%s%i%s_frames', this.pnumber, ip.Results.tracer, this.snumber, this.nacSuffix), ...
                         sprintf('%s%s%i%s%s%s', this.pnumber, ip.Results.tracer, this.snumber, this.nacSuffix, ip.Results.suffix, this.filetypeExt)));
        end
        
        function obj = petAtlas(this)
            obj = mlpet.PETImagingContext( ...
                cellfun(@(x) this.petObject(x, 'fqfn'), {'oc' 'oo' 'ho' 'tr'}));
            obj = obj.atlas;
        end      
        function p   = petPointSpread(~)
            p = mlpet.PETRegistry.instance.petPointSpread;
        end
 	end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

