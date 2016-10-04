classdef TestDataSingleton < mlderdeyn.StudyDataSingleton
	%% TESTDATASINGLETON  

	%  $Revision$
 	%  was created 21-Jan-2016 12:55:16
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

    methods (Static)
        function this = instance(qualifier)
            persistent instance_            
            if (exist('qualifier','var'))
                assert(ischar(qualifier));
                if (strcmp(qualifier, 'initialize'))
                    instance_ = [];
                end
            end            
            if (isempty(instance_))
                instance_ = mlderdeyn.TestDataSingleton();
            end
            this = instance_;
        end
        function        register(varargin)
            %% REGISTER
            %  @param []:  if this class' persistent instance
            %  has not been registered, it will be registered via instance() call to the ctor; if it
            %  has already been registered, it will not be re-registered.
            %  @param ['initialize']:  any registrations made by the ctor will be repeated.
            
            mlderdeyn.TestDataSingleton.instance(varargin{:});
        end
    end  

    %% PROTECTED
    
	methods (Access = protected)
 		function this = TestDataSingleton(varargin)
 			this = this@mlderdeyn.StudyDataSingleton(varargin{:});
            
            dt = mlsystem.DirTools(this.subjectsDir);
            fqdns = {};
            for di = 1:length(dt.dns)
                if (lstrfind(dt.dns{di}, 'mm0') || lstrfind(dt.dns{di}, 'wu0'))
                    fqdns = [fqdns dt.fqdns(di)];
                end
            end
            this.sessionDataComposite_ = ...
                mlpatterns.CellComposite( ...
                    cellfun(@(x) mlderdeyn.SessionData('studyData', this, 'sessionPath', x), ...
                    fqdns, 'UniformOutput', false));
            this.registerThis;
        end
        function registerThis(this)
            mlpipeline.StudyDataSingletons.register('test_derdeyn', this);
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

