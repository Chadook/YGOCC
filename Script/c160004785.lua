--Revived Brunette
function c160004785.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,33420078),aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160004785,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c160004785.cost)
	e1:SetTarget(c160004785.destg)
	e1:SetOperation(c160004785.desop)
	c:RegisterEffect(e1)

       local e2=Effect.CreateEffect(c)
       	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c160004785.efilter)
	c:RegisterEffect(e2)
       local e3=Effect.CreateEffect(c)
       e3:SetType(EFFECT_TYPE_SINGLE)
       e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
       c:RegisterEffect(e3)

	end
function c160004785.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_ZOMBIE)  and c:IsAbleToRemoveAsCost()
end
function c160004785.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160004785.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160004785.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160004785.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
end
function c160004785.desop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c160004785.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end