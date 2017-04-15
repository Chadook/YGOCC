--Chimera, Beast of the Shaderune
function c6666682.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c6666682.spcon)
	e1:SetOperation(c6666682.spop)
	c:RegisterEffect(e1)
	--Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c6666682.condition)
    e2:SetCost(c6666682.cost)
    e2:SetTarget(c6666682.target)
    e2:SetOperation(c6666682.activate)
    c:RegisterEffect(e2)
	--banish deck check
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6666682,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c6666682.bcondition)
	e3:SetTarget(c6666682.btarget)
	e3:SetOperation(c6666682.boperation)
	c:RegisterEffect(e3)
end
function c6666682.cfilter(c)
    return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c6666682.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c6666682.cfilter,tp,LOCATION_REMOVED,0,3,nil)
end
function c6666682.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c6666682.cfilter,tp,LOCATION_REMOVED,0,3,3,nil)
    Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c6666682.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c6666682.cfilter2(c)
	return c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()
end
function c6666682.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6666682.cfilter2,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c6666682.cfilter2,tp,LOCATION_REMOVED,0,3,3,e:GetHandler())
	Duel.SendtoDeck(g,nil,3,REASON_COST)
end
function c6666682.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c6666682.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c6666682.bcondition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c6666682.btarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c6666682.cfilter(c)
	return c:IsSetCard(0x900) or c:IsSetCard(0x901)
end
function c6666682.boperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	if g:GetCount()>0 then
		local sg=g:Filter(c6666682.cfilter,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToRemove() then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
