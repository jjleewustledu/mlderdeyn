classdef Test_Np755Files < matlab.unittest.TestCase
	%% TEST_NP755FILES 

	%  Usage:  >> results = run(mlderdeyn_unittest.Test_Np755Files)
 	%          >> result  = run(mlderdeyn_unittest.Test_Np755Files, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 20-Nov-2015 13:00:01
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/test/+mlderdeyn_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
 		registry
 		testObj
 	end

	methods (Test)
 		function test_afun(this)
 			import mlderdeyn.*;
 			this.assumeEqual(1,1);
 			this.verifyEqual(1,1);
 			this.assertEqual(1,1);
 		end
 	end

 	methods (TestClassSetup)
 		function setupNp755Files(this)
 			import mlderdeyn.*;
 			this.testObj = Np755Files;
 		end
 	end

 	methods (TestMethodSetup)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

