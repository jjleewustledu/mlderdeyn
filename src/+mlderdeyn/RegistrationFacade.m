classdef RegistrationFacade < mlfsl.RegistrationFacade
	%% REGISTRATIONFACADE  

	%  $Revision$
 	%  was created 18-Feb-2016 21:55:56
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlderdeyn/src/+mlderdeyn.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

    methods (Static)
        function registerTalairachInStudy
            studyd = mlpipeline.StudyDataSingletons.instance('derdeyn');
            iter = studyd.createIteratorForSessionData;
            while (iter.hasNext)
                try
                    sessd = iter.next;
                    rb = mlfsl.MultispectralRegistrationBuilder('sessionData', sessd);
                    rf = mlderdeyn.RegistrationFacade('sessionData', sessd, 'registrationBuilder', rb);
                    rf.registerTalairachWithPet;
                catch ME
                    handwarning(ME);
                end
            end
        end
    end

	methods
        function g = pet(this)
            if (isempty(this.pet_))
                s = this.sessionData.snumber;
                this.pet_ = mlpet.PETImagingContext( ...
                    this.annihilateEmptyCells({ this.oc(s) this.oo(s) this.ho(s) this.tr(s) }));
            end
            g = this.pet_;
        end
        function product = registerTalairachWithPet(this)
            %% REGISTERTALAIRACHWITHPET
            %  @return product is a struct with products as fields.
            
            product = this.initialTalairachProduct;
            
            msrb = mlfsl.MultispectralRegistrationBuilder('sessionData', this.sessionData);
            msrb.sourceImage = product.talairach;
            msrb.referenceImage = product.petAtlas;
            msrb = msrb.registerSurjective;
            product.tal_on_atl = msrb.product;
            product.xfm_tal_on_atl = msrb.xfm;
            
            [oc1_on_atl,product.xfm_atl_on_oc1] = this.petRegisterAndInvertTransform(product.oc1, product.petAtlas);
            [oo1_on_atl,product.xfm_atl_on_oo1] = this.petRegisterAndInvertTransform(product.oo1, product.petAtlas);
            [ho1_on_atl,product.xfm_atl_on_ho1] = this.petRegisterAndInvertTransform(product.ho1, product.petAtlas);
            [tr1_on_atl,product.xfm_atl_on_tr1] = this.petRegisterAndInvertTransform(product.tr1, product.petAtlas);
            
            if (this.recursion)
                this.pet_ = mlpet.PETImagingContext( ...
                    this.annihilateEmptyCells( ...
                        {oc1_on_atl oo1_on_atl ho1_on_atl tr1_on_atl}));
            end
            
            product = this.finalTalairachProduct(product);
            save(this.checkpointFqfilename('registerTalairachWithPet'), 'product');
        end 
        function product = initialTalairachProduct(this)            
            product.talairach = this.talairach;
            product.oc1       = this.oc(1);
            product.oo1       = this.petMotionCorrect(this.oo(1));
            product.ho1       = this.petMotionCorrect(this.ho(1));
            product.tr1       = this.petMotionCorrect(this.tr(1));
            
            pet = mlpet.PETImagingContext( ...
                    this.annihilateEmptyCells({ ...
                    product.oc1 product.oo1  product.ho1 product.tr1 }));
            product.petAtlas = pet.atlas;
        end
        function product = finalTalairachProduct(this, product)            
            product.talairach_on_oc1 = this.transform(product.tal_on_atl, product.xfm_atl_on_oc1, product.oc1);
            product.talairach_on_oo1 = this.transform(product.tal_on_atl, product.xfm_atl_on_oo1, product.oo1);
            product.talairach_on_ho1 = this.transform(product.tal_on_atl, product.xfm_atl_on_ho1, product.ho1);
            product.talairach_on_tr1 = this.transform(product.tal_on_atl, product.xfm_atl_on_tr1, product.tr1);
        end
        function masks = masksTalairachProduct(this, msk, product)
            assert(all(msk.niftid.size == product.talairach.niftid.size));
            this.sessionData.ensureNIFTI_GZ(msk);
            
            t = 'transformNearestNeighbor';
            masks.talairach_on_atl = this.transform(msk,                    product.xfm_tal_on_atl, product.petAtlas, t);
            masks.talairach_on_oc1 = this.transform(masks.talairach_on_atl, product.xfm_atl_on_oc1, product.oc1, t);
            masks.talairach_on_oo1 = this.transform(masks.talairach_on_atl, product.xfm_atl_on_oo1, product.oo1, t);
            masks.talairach_on_ho1 = this.transform(masks.talairach_on_atl, product.xfm_atl_on_ho1, product.ho1, t);
            masks.talairach_on_tr1 = this.transform(masks.talairach_on_atl, product.xfm_atl_on_tr1, product.tr1, t);
            save(this.checkpointFqfilename('masksTalairachProduct'), 'masks');
        end
		  
 		function this = RegistrationFacade(varargin)
 			%% REGISTRATIONFACADE
 			%  Usage:  this = RegistrationFacade()

 			this = this@mlfsl.RegistrationFacade(varargin{:});
        end
        
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

