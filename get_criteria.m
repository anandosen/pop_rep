function elig=get_criteria(lab_t,t)
    nlab=size(find(lab_t>0),2);
    lab_elig_list={'tr_elig_hba1c.txt'; 'tr_elig_gluc.txt'; 'tr_elig_crtn.txt'; 'tr_elig_bilirubin.txt'; 'tr_elig_ldl.txt'; 'tr_elig_ast.txt'; 'tr_elig_alt.txt'; 'tr_elig_hdl.txt'; 'tr_elig_hgb.txt'; 'tr_elig_triglyc.txt'; 'tr_elig_chol.txt'; 'tr_elig_gfr.txt'};
    lab_elig_list=char(lab_elig_list);
    lab_elig_no=lab_elig_list(lab_t,:);
    
    elig=zeros(nlab+1,2);
    for i=1:nlab
        fil=lab_elig_no(i,:);
        feat_elig=dlmread(strtrim(fil));
        elig(i,1)=feat_elig(t,2);
        elig(i,2)=feat_elig(t,3);
    end
    
    age_elig=dlmread('tr_elig_age.txt');
    elig(nlab+1,1)=age_elig(t,2);
    elig(nlab+1,2)=age_elig(t,3);
end