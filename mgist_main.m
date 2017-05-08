% determining which of the eligibility criteria will be used in each trial

lab_elig=dlmread('trials_lab_elig.txt');
cat_elig=dlmread('cat_trials_data.txt');
gender_elig=dlmread('trials_by_gender.txt');

trials=lab_elig(:,1);

lab_elig(:,1)=[];
cat_elig(:,1)=[];

total_lab=size(lab_elig,2);
total_cat=size(cat_elig,2);

% creating a list of all traits from individual feature files
lab_traits= textread('lab_fil_list.txt','%s','delimiter','\n');
for i=1:total_lab
   temp=char(lab_traits{i});
   pos=strfind(temp,'.');
   temp(pos:end)=[];
   lab_traits{i}=temp;
end
cat_traits= textread('trials_by_feat.txt', '%s', 'delimiter','\n');%','delimiter','\n');%{'pregnancy','breast_feeding', 'cancer', 'endocrine', 'liver', 'type1d', 'cardivascular', 'surgery','dialysis','metformin'};
for i=1:total_cat
   temp=char(cat_traits{i});
   pos=strfind(temp,'_');
   temp(pos:end)=[];
   cat_traits{i}=temp;
end
trial_full_data=zeros(size(trials,1), total_cat+total_lab+3);

vnames{1}= 'gender';
for i=2:total_cat+1
    vnames{i}=cat_traits{i-1};
end
for i=total_cat+2:total_cat+total_lab+1
    vnames{i}=lab_traits{i-total_cat-1};
end
vnames{total_cat+total_lab+2}='age';
vnames{total_cat+total_lab+3}='overall';

% reading the target population and rearranging features
tp_full=dlmread('dummy_target_pop.txt');
temp=tp_full;
temp(:,total_cat+2:total_cat+total_lab+1)=tp_full(:,2:total_lab+1);
temp(:,2:total_cat+1)=tp_full(:,total_lab+2:total_cat+total_lab+1);
tp_full=temp;

% main loop for calculating GIST scores of trials
for t=1:size(trials,1)
    lab_t=find(lab_elig(t,:));
    cat_t=find(cat_elig(t,:));
    nlab=size(find(lab_t>0),2);
    ncat=size(find(cat_t>0),2);
    ind=[1 cat_elig(t,:) lab_elig(t,:) 1];
    tp=tp_full(:,find(ind));
    npat=size(tp,1);
    catv=categorical(tp(:,1:ncat+1));
    
    % normalizing the features for similar range of values
    m=mean(tp(:,ncat+2:ncat+nlab+2));
    s=std(tp(:,ncat+2:ncat+nlab+2));
    tp1=tp;
    for i=ncat+2:ncat+nlab+2
        tp(:,i)=(tp(:,i)-m(i-ncat-1))./s(i-ncat-1);
    end

    tp2=tp;

    % reading eligibility criteria
    
    elig=get_criteria(lab_t,t);

    %Apply feature weights
    app_weights=1;
    if (app_weights==1)
        w=strin_weights(elig,tp1,ncat);
    end    
    w=w(ncat+2:ncat+nlab+2);
       
    for i=1:npat
        tp(i,ncat+2:ncat+nlab+2)=tp(i,ncat+2:ncat+nlab+2).*w';
    end

    % creating table of patient features. 
    tbl=array2table(catv);

    for i=ncat+2:ncat+nlab+2
        varname=strcat('Var',num2str(i));
        tbltemp=table(tp(:,i), 'VariableNames', {varname});
        tbl=[tbl tbltemp];
    end

    % applying SVM regression model
    pred=strcat('Var',num2str(ncat+nlab+2));
    mdl = fitrsvm(tbl,pred,'KernelFunction','gaussian','KernelScale','auto');
    ypred = resubPredict(mdl);
    
    residuals=abs(ypred-tp(:,ncat+nlab+2));
    weights=1./(1.0+abs(residuals));

    elig1=elig;

     
    % normalizing the eligibility criteria accordingly
    for i=1:nlab+1
        elig(i,:)=(elig(i,:)-m(i))./s(i);
    end

    
    feat=size(elig,1)+1;

    % determining eligibility per patient per feature
    indic=gmult_cat(tp2,elig,gender_elig(t),catv,ncat);
    
    % calculating mGIST and sGIST
    gmulti=sum((sum(indic,2) == ncat+nlab+2).*weights)/sum(weights);
    
    for i=1:ncat+nlab+2
     gsing(i)=sum(indic(:,i).*weights)/sum(weights);
    end
    
    gs_cat=ones(1,total_cat).*100;
    gs_cat(1,cat_t)=gsing(2:ncat+1);
    gs_lab=ones(1,total_lab).*100;
    gs_lab(1,lab_t)=gsing(ncat+2:ncat+nlab+1);
    gfull=[gsing(1) gs_cat gs_lab gsing(ncat+nlab+2) gmulti];
    trial_full_data(t,:)=gfull;
end

% storing results
resulttable=array2table(trial_full_data,'VariableNames',vnames);
nct_id=trials;
resulttable=[table(nct_id) resulttable];
dlmwrite('results_table.txt', table2array(resulttable),'delimiter', ' ','precision','%8.2f');
writetable(resulttable, 'results_table.csv');
