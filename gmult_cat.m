function G=gmult_cat(tp2,elig,gend_elig,catv,ncat)
    feat=size(elig,1);
    G=zeros(size(tp2));
    %npat=size(tp2,1);
    tp3=tp2(:,ncat+2:end);
    for i=1:feat
        G(:,i+ncat+1)=tp3(:,i)>= elig(i,1) & tp3(:,i)<= elig(i,2);
        %if (isempty(find(add_elig(:,1)==i))==0)
            %pos=add_elig((find(add_elig(:,1)==i)),:);
            %G(:,i+1)=G(:,i+1) | (data(:,i)>= pos(2) & data(:,i)<= pos(3));
        %end
    end

    G(:,1)=1;
    if (gend_elig==1)
        G(find(tp2(:,1)==2),1)=0;
    end
    
    if (gend_elig==2)
        G(find(tp2(:,1)==1),1)=0;
    end
    catv=catv(:,2:end);
    G(:,2:ncat+1)=double(catv)-1;
    
end