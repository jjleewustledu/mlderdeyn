classdef Np755Files 
	%% NP755FILES  

	%  $Revision$
 	%  was created 20-Nov-2015 13:00:01
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
    
 	properties (Constant)
        ECAT_FILE_SUFFIX = '.nii.gz'
        DEFAULT_MASK = 'cerebrum_mask'
    end
    
	properties (Dependent)
        pnumPath
        dtaFqfilename
        ecatFqfilename
        maskFqfilename
        tscFqfilename
        
        pnum
        scanIndex
        region
        tracerId
        tscId
    end 

    methods %% GET
        function p = get.pnumPath(this)
            p = this.pnumPath_;
        end
        function f = get.tscFqfilename(this)
            f = fullfile( ...
                this.pnumPath, 'fsl', ...
                sprintf('%s%s%i.tsc', this.pnum, this.tscId, this.scanIndex));
        end
        function f = get.ecatFqfilename(this)
            f = fullfile( ...
                this.pnumPath, 'fsl', ...
                sprintf('%s%s%i%s', this.pnum, this.tracerId, this.scanIndex, this.ECAT_FILE_SUFFIX));
        end
        function f = get.dtaFqfilename(this)
            f = fullfile( ...
                this.pnumPath, 'fsl', ...
                sprintf('%sg%i.dta', this.pnum, this.scanIndex));
        end
        function f = get.maskFqfilename(this)
            if (isempty(       this.region_) || ...
                lstrfind(lower(this.region_), 'whole') || ...
                lstrfind(lower(this.region_), 'brain') );
                f = sprintf('%s_on_%s%s%i_sumt.nii.gz', this.DEFAULT_MASK, this.pnum, this.tracerId, this.scanIndex);
            else
                f = this.region_;
                if (~lstrfind(this.region_, '.nii.gz'))
                    f = sprintf('%s.nii.gz', f);
                end
            end
            f = fullfile( ...
                this.pnumPath, 'fsl', f);
        end
        
        function p = get.pnum(this)
            p = str2pnum(this.pnumPath);
        end
        function s = get.scanIndex(this)
            s = this.scanIndex_;
        end
        function r = get.region(this)
            r = this.region_;
        end
        function id = get.tracerId(this) %#ok<MANU>
            id = 'ho';
        end
        function id = get.tscId(this) %#ok<MANU>
            id = 'wb';
        end
    end
    
	methods 		  
 		function this = Np755Files(varargin) 
 			%% NP755FILES 
 			%  Usage:  this = Np755Files() 

            ip = inputParser;
            addParameter(ip, 'pnumPath', pwd, @(x) lexist(x, 'dir') && lstrfind(x, 'p'));
            addParameter(ip, 'scanIndex', 1, @isnumeric);
            addParameter(ip, 'region', '', @ischar);
            parse(ip, varargin{:});
 			 
            this.pnumPath_  = ip.Results.pnumPath;            
            this.scanIndex_ = ip.Results.scanIndex;
            this.region_    = ip.Results.region;
 		end 
    end 
    
    %% PROTECTED
    
    properties (Access = 'protected')
        pnumPath_
        scanIndex_
        region_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

