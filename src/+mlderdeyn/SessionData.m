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
            %         'ac'          is logical
            %         'rnumber'     is numeric
            %         'sessionPath' is a path to the session data
            %         'studyData'   is a mlpipeline.StudyDataSingleton
            %         'snumber'     is numeric
            %         'tracer'      is char
            %         'vnumber'     is numeric
            %         'tag'         is appended to the fileprefix

 			this = this@mlpipeline.SessionData(varargin{:});
            this.ac_ = true;
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
        
        function loc = cossLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.vLocation, 'ECAT_EXACT', 'coss', ''));
        end
        function loc = hdrinfoLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.vLocation, 'ECAT_EXACT', 'hdr_backup', ''));
        end
        function loc = petLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.vLocation, 'ECAT_EXACT', 'pet', ''));
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
    
    methods (Access = protected)        
        function obj = petObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.petLocation, ...
                         sprintf('%s%s%i_frames', this.pnumber, ip.Results.tracer, this.snumber), ...
                         sprintf('%s%s%i%s%s', this.pnumber, ip.Results.tracer, this.snumber, ip.Results.suffix, this.filetypeExt)));
        end        
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

