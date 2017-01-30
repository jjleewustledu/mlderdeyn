classdef StudyDataSingleton < mlpipeline.StudyDataSingleton
	%% StudyDataSingleton  

	%  $Revision$
 	%  was created 21-Jan-2016 12:55:16
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    properties 
        subjectsFolder = {'np755' 'np797'}
    end
    
    methods (Static)
        function this = instance(varargin)
            persistent instance_
            if (~isempty(varargin))
                instance_ = [];
            end
            if (isempty(instance_))
                instance_ = mlderdeyn.StudyDataSingleton(varargin{:});
            end
            this = instance_;
        end
    end
    
    methods
        function d    = freesurfersDir(this)
            d = this.subjectsDir;
        end
        function        register(this, varargin)
            %% REGISTER this class' persistent instance with mlpipeline.StudyDataSingletons
            %  using the latter class' register methods.
            %  @param key is any registration key stored by mlpipeline.StudyDataSingletons; default 'derdeyn'.
            
            ip = inputParser;
            addOptional(ip, 'key', 'derdeyn', @ischar);
            parse(ip, varargin{:});
            mlpipeline.StudyDataSingletons.register(ip.Results.key, this);
        end
        function this = replaceSessionData(this, varargin)
            %% REPLACESESSIONDATA
            %  @param [parameter name,  parameter value, ...] as expected by mlderdeyn.SessionData are optional;
            %  'studyData' and this are always internally supplied.
            %  @returns this.

            this.sessionDataComposite_ = mlpatterns.CellComposite({ ...
                mlderdeyn.SessionData('studyData', this, varargin{:})});
        end
        function sess = sessionData(this, varargin)
            %% SESSIONDATA
            %  @param [parameter name,  parameter value, ...] as expected by mlderdeyn.SessionData are optional;
            %  'studyData' and this are always internally supplied.
            %  @returns for empty param:  mlpatterns.CellComposite object or it's first element when singleton, 
            %  which are instances of mlderdeyn.SessionData.
            %  @returns for non-empty param:  instance of mlderdeyn.SessionData corresponding to supplied params.
            
            if (isempty(varargin))
                sess = this.sessionDataComposite_;
                if (1 == length(sess))
                    sess = sess.get(1);
                end
                return
            end
            sess = mlderdeyn.SessionData('studyData', this, varargin{:});
        end 
        function d    = subjectsDir(this)
            d = cellfun(@(x) fullfile(getenv('CVL'), x, ''), this.subjectsFolder, 'UniformOutput', false);
        end
        function f    = subjectsDirFqdns(this)
            dt = mlsystem.DirTools(this.subjectsDir);
            f = {};
            for di = 1:length(dt.dns)
                e = regexp(dt.dns{di}, 'mm\d{2}-\d{3}', 'match');
                if (~isempty(e))
                    f = [f dt.fqdns(di)]; %#ok<AGROW>
                end
            end
        end 
    end
    
    %% PROTECTED
    
	methods (Access = protected)
 		function this = StudyDataSingleton(varargin)
 			this = this@mlpipeline.StudyDataSingleton(varargin{:});
        end
        function this = assignSessionDataCompositeFromPaths(this, varargin)
            if (isempty(this.sessionDataComposite_))
                for v = 1:length(varargin)
                    if (ischar(varargin{v}) && isdir(varargin{v}))                    
                        this.sessionDataComposite_ = ...
                            this.sessionDataComposite_.add( ...
                                mlderdeyn.SessionData('studyData', this, 'sessionPath', varargin{v}));
                    end
                end
            end
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

