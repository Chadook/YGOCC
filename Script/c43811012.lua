--Phantasm Creation
function c43811012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c43811012.condition)
	e1:SetTarget(c43811012.target)
	e1:SetOperation(c43811012.activate)
	c:RegisterEffect(e1)
end
function c43811012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,43811012)==0
end
function c43811012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43811012.cfilter,tp,LOCATION_DECK,0,1,nil)
	 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.RegisterFlagEffect(tp,43811012,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,0,0)
end
function c43811012.cfilter(c)
	return c:IsSetCard(0x90e) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function c43811012.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x90e) and c:GetLevel()<lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c43811012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43811012.cfilter,tp,LOCATION_DECK,0,1,5,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:GetCount()>0 then
		sg=g:Filter(c43811012.cfilter,nil)
		local lc=sg:GetFirst()
		local lv=0
		while lc do
			lv=lv+lc:GetLevel()
			lc=sg:GetNext()
		end
		if lv==0 then return end
		if Duel.IsExistingMatchingCard(c43811012.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) then
			local g=Duel.SelectMatchingCard(tp,c43811012.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
				g:GetFirst():RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
				g:GetFirst():RegisterEffect(e2,true)
			end
		end
	end
end
