function c11260.initial_effect(c)
	--SPSEARCH
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11260,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11260+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11260.target)
	e1:SetOperation(c11260.activate)
	c:RegisterEffect(e1)
end
function c11260.filter1(c,e,tp)
	return c:IsSetCard(0x2BF2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11260.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11260.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11260.filter2(c)
	return c:IsSetCard(0x2BF2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11260.filter3(c)
	return c:IsAbleToDeck()
end
function c11260.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11260.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local g1=Duel.GetMatchingGroup(c11260.filter3,tp,LOCATION_HAND,0,nil)
		local g2=Duel.GetMatchingGroup(c11260.filter2,tp,LOCATION_DECK,0,nil)
		if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11260,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg1=g1:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,tg1)
			Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg2=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(tg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg2)
		end
	end
end
