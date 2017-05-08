function fw = strin_weights(elig,tp1,ncat)
    no_feat=size(tp1,2);
    fw=zeros(no_feat,1);
    for i=ncat+2:no_feat
        s=intersect(find(tp1(:,i)>=elig(i-ncat-1,1)),find(tp1(:,i)<=elig(i-ncat-1,2)));
        fw(i)=max(1-size(s,1)/size(tp1,1),0.01);
    end
    
end
