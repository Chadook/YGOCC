--Bladewing's Aerial Advantage
function c101010371.initial_effect(c)
--Discard 1 "Blademaster" or "Bladewing" monster; Draw 2 cards, then if your opponent controls more monsters than you do, change 1 monster your opponent controls to face-down Defense Position, also, if you control no monsters, Draw 1 card. You can only activate 1 "Bladewing's Aerial Advantage" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010371+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101010371.cost)
	e1:SetTarget(c101010371.target)
	e1:SetOperation(c101010371.activate)
	c:RegisterEffect(e1)
end
function c101010371.cfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101010371.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010371.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101010371.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101010371.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101010371.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101010371.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	local cf=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if cf<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,c101010371.filter,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
