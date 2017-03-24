 --Lunar Cycles
function c4242572.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4242572)
	e1:SetCost(c4242572.cost)
	e1:SetTarget(c4242572.target)
	e1:SetOperation(c4242572.activate)
	c:RegisterEffect(e1)
end
function c4242572.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsDiscardable()
end
function c4242572.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242572.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c4242572.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleHand(tp)
end
function c4242572.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c4242572.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end