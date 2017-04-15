--Anthar, Shaderune Demon Summoner
function c6666673.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666673,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c6666673.spcost)
	e1:SetTarget(c6666673.sptg)
	e1:SetOperation(c6666673.spop)
	c:RegisterEffect(e1)
	--banish deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666673,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c6666673.condition)
	e2:SetTarget(c6666673.target)
	e2:SetOperation(c6666673.operation)
	c:RegisterEffect(e2)
end
function c6666673.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c6666673.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6666673.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c6666673.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c6666673.filter(c,e,tp)
	return c:IsSetCard(0x900) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6666673.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6666673.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c6666673.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6666673.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c6666673.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c6666673.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c6666673.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function c6666673.cfilter2(c)
	return c:IsSetCard(0x900) or c:IsSetCard(0x901)
end
function c6666673.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		local sg=g:Filter(c6666673.cfilter2,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToRemove() then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
