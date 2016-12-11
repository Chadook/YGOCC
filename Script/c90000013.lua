--Night Clock Illusion
function c90000013.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c90000013.cost)
	e1:SetTarget(c90000013.target)
	e1:SetOperation(c90000013.operation)
	c:RegisterEffect(e1)
end
function c90000013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c90000013.filter1(c,e,tp)
	local lv=c:GetOriginalLevel()
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c90000013.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,lv+1)
end
function c90000013.filter2(c,e,tp,mc,lv)
	return c:GetLevel()==lv and c:IsSetCard(0x3) and c:IsType(TYPE_FUSION) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c90000013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c90000013.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90000018.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90000013.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000013.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetLevel()+1)
	local sc=g:GetFirst()
	if sc then
		Duel.SendtoGrave(tc,REASON_COST)
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end