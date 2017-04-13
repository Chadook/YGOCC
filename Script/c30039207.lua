--Levelution Mutation
function c30039207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,30039207+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c30039207.cost)
	e1:SetTarget(c30039207.target)
	e1:SetOperation(c30039207.activate)
	c:RegisterEffect(e1)
end
function c30039207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c30039207.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0x12F)
		and (Duel.IsExistingMatchingCard(c30039207.filter2,tp,LOCATION_DECK,0,1,nil,lv+1,e,tp) or Duel.IsExistingMatchingCard(c30039207.filter2,tp,LOCATION_DECK,0,1,nil,lv-1,e,tp))
end
function c30039207.filter2(c,lv,e,tp)
	return c:IsSetCard(0x12F) and (c:GetLevel()==lv+1 or c:GetLevel()==lv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30039207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c30039207.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c30039207.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c30039207.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30039207.filter2,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end