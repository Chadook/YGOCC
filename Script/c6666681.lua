--Hecate, Shaderune Sorceress
function c6666681.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x900),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1)
	c:EnableReviveLimit()
	--ret&draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6666681,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c6666681.target1)
	e1:SetOperation(c6666681.operation1)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666681,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c6666681.cost)
	e2:SetCondition(c6666681.cond)
	e2:SetOperation(c6666681.opd)
	c:RegisterEffect(e2)
end
function c6666681.filter1(c)
	return c:IsAbleToDeck()
end
function c6666681.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6666681.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6666681.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c6666681.filter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c6666681.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg:IsExists(c6666681.filter1,1,nil,e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c6666681.cond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	return not c:IsDisabled() and d:IsFaceup() and d:IsSetCard(0x900)
end
function c6666681.opd(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c6666681.cfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c6666681.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6666681.cfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c6666681.cfilter,tp,LOCATION_REMOVED,0,2,2,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end