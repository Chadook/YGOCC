--Settlement of the Soul
function c1013069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1013069.lpcon)
	e2:SetOperation(c1013069.lpop)
	e2:SetLabel(0)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e2)
	e3:SetCountLimit(1,1013069)
	e3:SetCost(c1013069.spcost)
	e3:SetTarget(c1013069.sptg)
	e3:SetOperation(c1013069.spop)
	c:RegisterEffect(e3)
end
function c1013069.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_MZONE and c:IsType(TYPE_MONSTER)
		and (c:GetLevel()>0 or c:GetRank()>0)
end
function c1013069.lpcon(e,tp,eg,ev,ep,re,r,rp)
	return eg:IsExists(c1013069.cfilter,1,nil,tp)
end
function c1013069.lpop(e,tp,eg,ev,ep,re,r,rp)
	local rk=0
	local lv=0
	local g=eg:Filter(c1013069.cfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_XYZ) then
			rk=rk+tc:GetRank()
		else
			if tc:IsType(TYPE_MONSTER) then
				lv=lv+tc:GetLevel()
			end
		end
		tc=g:GetNext()
	end
	local rv=lv+rk
	if rv==0 then return end
	if Duel.Recover(tp,rv*100,REASON_EFFECT)~=0 then
		rv=rv+e:GetLabel()
		e:SetLabel(rv)
	end
end
function c1013069.spcost(e,tp,eg,ev,ep,re,r,rp,chk)
	local val=e:GetLabelObject():GetLabel()
	if chk==0 then return e:GetHandler():IsAbleToGrave() and val~=0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1013069.spfilter(c,e,tp,val)
	return c:GetAttack()>=val and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1013069.sptg(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	local val=e:GetLabelObject():GetLabel()
	if not val then return end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c1013069.spfilter(chkc,e,tp,val) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c1013069.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,val) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1013069.spop(e,tp,eg,ev,ep,re,r,rp)
	local val=e:GetLabelObject():GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1013069.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,val)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end