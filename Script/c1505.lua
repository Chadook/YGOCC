function c1505.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,0x100000),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(1505,0))
		e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCost(c1505.cost)
		e1:SetTarget(c1505.destg)
		e1:SetOperation(c1505.desop)
		c:RegisterEffect(e1)
	end
function c1505.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end	
function c1505.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_PSYCHO)) and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK)
end
function c1505.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c1505.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c1505.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,1,tp,LOCATION_DECK)
end
function c1505.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	if g1:GetFirst():IsRelateToEffect(e) and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		local hg=g2:Filter(c1505.tgfilter,nil,e)
		Duel.SendtoGrave(hg,REASON_EFFECT)
	end
end