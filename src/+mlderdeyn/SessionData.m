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
        rawdataDir
        rawdataFolder
        resolveTag = ''
        vfolder
    end
    
    properties (Dependent)
        petBlur
        vLocation
    end
    
    methods %% GET
        function g = get.petBlur(~)
            g = mlpet.PETRegistry.instance.petPointSpread;
        end
        function g = get.vLocation(this)
            if (iscell(this.sessionPath))
                g = this.sessionPath{1};
                return
            end
            g = this.sessionPath;
        end
    end
    
    methods
                
        %% IMRData
               
        function obj = aparcAsegBinarized(this, varargin)
            fqfn = fullfile(this.mriLocation, sprintf('aparcAsegBinarized%s', this.filetypeExt));
            obj  = this.fqfilenameObject(fqfn, varargin{:});
        end
        function obj = ep2d(this, varargin)
            obj = this.mrObject('ep2d_default_mcf', varargin{:});
        end
        function obj = mprage(this, varargin)
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
        
        function obj = cbf(this, varargin)
            obj = this.petG3Object('cbf', varargin{:});
        end
        function obj = cbv(this, varargin)
            obj = this.petG3Object('cbv', varargin{:});
        end
        function fqfn = crv(this, varargin)
            fp   = this.petObject(this.tracer, 'typ', 'fp');
            fqfn = fullfile(this.petLocation, [fp '.crv']);
        end
        function fqfn = dcv(this, varargin)
            fp   = this.petObject(this.tracer, 'typ', 'fp');
            fqfn = fullfile(this.petLocation, [fp '.dcv']);
        end
        function obj = oc(this, varargin)
            ip = inputParser;
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.petLocation, ...
                         sprintf('%soc%i_frames', this.pnumber, this.snumber), ...
                         sprintf('%soc%i_03%s%s', this.pnumber, this.snumber, ip.Results.tag, this.filetypeExt)));
        end
        function obj = pet(this, varargin)
            obj = this.petG3Object(this.tracer, varargin{:});
        end
        function obj = mask(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.sessionPath, 'petaif', ...
                         sprintf('b%s_mask_on_%s_meanvol%s', ...
                         this.mprage('typ', 'fp'), this.ho('typ', 'fp'), this.filetypeExt)));
        end
        function obj = oef(this, varargin)
            obj = this.petG3Object('oef', varargin{:});
        end
        function p   = pie(~)
            p = 5.2038;
        end
        function obj = petAtlas(this)
            obj = mlpet.PETImagingContext( ...
                cellfun(@(x) this.petObject(x, 'fqfn'), {'oc' 'oo' 'ho' 'tr'}));
            obj = obj.atlas;
        end      
        function p   = petPointSpread(~)
            p = mlpet.PETRegistry.instance.petPointSpread;
        end
        function obj = petObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.petLocation, ...
                         sprintf('%s%s%i_frames', this.pnumber, lower(ip.Results.tracer), this.snumber), ...
                         sprintf('%s%s%i%s%s', this.pnumber, lower(ip.Results.tracer), this.snumber, ip.Results.tag, this.filetypeExt)));
        end  
        function obj = petG3Object(this, varargin)
            ip = inputParser;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'tag', '_g3', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.petLocation, ...
                         sprintf('%s%s%i%s%s', ...
                                 this.pnumber, lower(ip.Results.tracer), this.snumber, ip.Results.tag, this.filetypeExt)));
        end     
        function [dt0_,date_] = readDatetime0(~)
            dt0_ = datetime;
            date_ = datetime(dt0_.Year, dt0_.Month, dt0_.Day);
        end
        
        %%        
        
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
            this.attenuationCorrected_ = true;
            this.tracer_ = 'HO';
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

