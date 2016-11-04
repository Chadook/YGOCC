--Valkyrus Hinata of Gust Vine
function c16000445.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
		local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c16000445.fscondition)
	e0:SetOperation(c16000445.fsoperation)
	c:RegisterEffect(e0)
	--discard deck & draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16000445)
	e1:SetTarget(c16000445.distg)
	e1:SetOperation(c16000445.drop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(16000445,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,16000445)
	e3:SetCondition(c16000445.condition)
	e3:SetCost(c16000445.cost)
	e3:SetTarget(c16000445.target)
	e3:SetOperation(c16000445.operation)
	c:RegisterEffect(e3)
end

function c16000445.ffilter(c)
	return  c:IsSetCard(0x786d)   and c:IsLocation(LOCATION_MZONE) or c:IsHasEffect(500317451)
end
function c16000445.fscondition(e,g,gc)
	if g==nil then return true end
	if gc then return false end
	return g:IsExists(c16000445.ffilter,3,nil)
end
function c16000445.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	Duel.SetFusionMaterial(eg:FilterSelect(tp,c16000445.ffilter,3,63,nil))
end
function c16000445.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c16000445.cfilter(c)
	return c:IsSetCard(0x786d) and c:IsType(TYPE_MONSTER)and c:IsLocation(LOCATION_GRAVE)
end
function c16000445.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c16000445.cfilter,nil)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c16000445.filter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c16000445.condition(e,tp,eg,ep,ev,re,r,rp)
	return   tp~=ep and Duel.GetCurrentChain()==0 and eg:IsExists(c16000445.filter,1,nil) 
end
function c16000445.cfilter(c)
	return c:IsSetCard(0x786d) and c:IsType(TYPE_MONSTER)  and c:IsAbleToRemoveAsCost()
end
function c16000445.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000445.cfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c16000445.cfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)

end
function c16000445.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	local g=eg:Filter(c16000445.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end
end
function c16000445.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	-- local g=eg:Filter(c16000445.filter,nil)
	Duel.NegateSummon(eg)
	if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)~=0 then
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		local tc=eg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetTarget(c16000445.aclimit)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetLabel(tc:GetCode())
		Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
        Duel.RegisterEffect(e2,tp)


	end
end
function c16000445.aclimit(e,c)--re,tp)
	return c:IsCode(e:GetLabel())-- and c:IsType(TYPE_MONSTER)
end
function c16000445.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c16000445.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		ct=0
		c:ResetFlagEffect(1082946)
	end
end

