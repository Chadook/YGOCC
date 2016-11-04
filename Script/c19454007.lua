--Bargin of Eternity
function c19454007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19454007)
	e1:SetCost(c19454007.cost)
	e1:SetTarget(c19454007.target)
	e1:SetOperation(c19454007.activate)
	c:RegisterEffect(e1)
end
function c19454007.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe6b)
end
function c19454007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c19454007.tfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c19454007.tfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c19454007.filter(c,e,tp,code)
	return c:IsSetCard(0xe6b) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c19454007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c19454007.filter,tp,LOCATION_DECK,0,1,nil,e,tp,code) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19454007.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19454007.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)>0 then
		g:GetFirst():CompleteProcedure()
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp/2)
	end
end