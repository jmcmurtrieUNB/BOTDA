function rawdata=botdadenois(RawData,type)

[s,t]=size(RawData);
denoised_visu_wave = zeros(s,t);
d_2 = squeeze(RawData);

if type==1%test

    for j=1:s
%     for i=1:t
        d = squeeze(d_2(j,:));
        lev = 3;
% % %         minimax_denoised = wden(d,'minimaxi','s','mln',lev,'sym4');
% % %         denoised_minimax_wave(k,:,i)= minimax_denoised;
        lev = 3;
%         hsure_denoised = wden(d,'heursure','s','sln',lev,'sym4');
%         denoised_hsure_wave(k,:,i)= hsure_denoised;
        
        visu_denoised = wden(d,'sqtwolog','s','sln',lev,'sym4');
        denoised_visu_wave(j,:)= visu_denoised;
        
% %         rsure_denoised = wden(d,'rigrsure','s','sln',lev,'sym4');
% %         denoised_rsure_wave(k,:,i)= rsure_denoised;
        
        % Bayes Shrinkage
        lev = 3;
% %         bayes_denoised = wden_mohsen(d,'bayes','s','sln',lev,'sym4');
% %         denoised_bayes_wave(k,:,i)= bayes_denoised;
        
%     end

    end
end



 
if type==2%test

    for j=1:116
%     for i=1:t
        d = squeeze(d_2(j,:));
        lev = 3;
% % %         minimax_denoised = wden(d,'minimaxi','s','mln',lev,'sym4');
% % %         denoised_minimax_wave(k,:,i)= minimax_denoised;
        lev = 3;
%         hsure_denoised = wden(d,'heursure','s','sln',lev,'sym4');
%         denoised_hsure_wave(k,:,i)= hsure_denoised;
        
       hsure_denoised = wden(d,'heursure','s','mln',lev,'sym4');
        denoised_visu_wave(:,i)= hsure_denoised;
        
% %         rsure_denoised = wden(d,'rigrsure','s','sln',lev,'sym4');
% %         denoised_rsure_wave(k,:,i)= rsure_denoised;
        
        % Bayes Shrinkage
        lev = 3;
% %         bayes_denoised = wden_mohsen(d,'bayes','s','sln',lev,'sym4');
% %         denoised_bayes_wave(k,:,i)= bayes_denoised;
        
%     end
j
    end
end

        
if type==3%test

    for j=1:116
%     for i=1:t
        d = squeeze(d_2(j,:));
        lev = 3;
% % %         minimax_denoised = wden(d,'minimaxi','s','mln',lev,'sym4');
% % %         denoised_minimax_wave(k,:,i)= minimax_denoised;
        lev = 3;
%         hsure_denoised = wden(d,'heursure','s','sln',lev,'sym4');
%         denoised_hsure_wave(k,:,i)= hsure_denoised;
        
        rsure_denoised = wden(d,'rigrsure','s','mln',lev,'sym4');
        denoised_visu_wave(:,i)= rsure_denoised;
        
% %         rsure_denoised = wden(d,'rigrsure','s','sln',lev,'sym4');
% %         denoised_rsure_wave(k,:,i)= rsure_denoised;
        
        % Bayes Shrinkage
        lev = 3;
% %         bayes_denoised = wden_mohsen(d,'bayes','s','sln',lev,'sym4');
% %         denoised_bayes_wave(k,:,i)= bayes_denoised;
        
%     end
j
    end
end

  
if type==4%test

    for j=1:116
%     for i=1:t
        d = squeeze(d_2(j,:));
        lev = 3;
% % %         minimax_denoised = wden(d,'minimaxi','s','mln',lev,'sym4');
% % %         denoised_minimax_wave(k,:,i)= minimax_denoised;
        lev = 3;
%         hsure_denoised = wden(d,'heursure','s','sln',lev,'sym4');
%         denoised_hsure_wave(k,:,i)= hsure_denoised;
       bayes_denoised = wden_mohsen(d,'bayes','s','mln',lev,'sym4');
        denoised_visu_wave(:,i)= bayes_denoised;

        
% %         rsure_denoised = wden(d,'rigrsure','s','sln',lev,'sym4');
% %         denoised_rsure_wave(k,:,i)= rsure_denoised;
        
        % Bayes Shrinkage
        lev = 3;
% %         bayes_denoised = wden_mohsen(d,'bayes','s','sln',lev,'sym4');
% %         denoised_bayes_wave(k,:,i)= bayes_denoised;
        
%     end
j
    end
end

rawdata=denoised_visu_wave;



