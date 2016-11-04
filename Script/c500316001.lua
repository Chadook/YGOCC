--Reezia, NecroMancer of Gust Vine
function c500316001.initial_effect(c)

		local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TO_DECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,500316001)
	e2:SetCondition(c500316001.con)
	e2:SetCost(c500316001.tgcost)
	e2:SetTarget(c500316001.tg)
	e2:SetOperation(c500316001.op)
	c:RegisterEffect(e2)
end
function c500316001.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c500316001.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500316001.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500316001.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end	
function c500316001.filter(c)
	return  c:IsType(TYPE_MONSTER) and c:IsSetCard(0x786d) and c:IsAbleToDeck()
end
function c500316001.filter2(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c500316001.con(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsReason(REASON_EFFECT)
end
function c500316001.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c500316001.filter,tp,LOCATION_REMOVED,0,2,nil)
		and Duel.IsExistingTarget(c500316001.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c500316001.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c500316001.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c500316001.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
end
end